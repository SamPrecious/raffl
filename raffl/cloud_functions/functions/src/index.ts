import * as admin from 'firebase-admin';
admin.initializeApp();

import {
    onDocumentCreated,
  } from "firebase-functions/v2/firestore";

// Dependencies for task queue functions.
const {onTaskDispatched} = require("firebase-functions/v2/tasks");
//const {onRequest} = require("firebase-functions/v2/https");
const {getFunctions} = require("firebase-admin/functions");
const {onCall} = require("firebase-functions/v2/https");

// Dependencies for image backup.
const {GoogleAuth} = require("google-auth-library");
let auth = new GoogleAuth({
    scopes: 'https://www.googleapis.com/auth/cloud-platform',
});
  

//This function is automatically invoked when a listing timestamp ends, and will select a winner at random
exports.selectWinnerQueue = onTaskDispatched({region: "europe-west2"}, async (request: any) => {
    //TODO Change listingID to function input when done with testing
    console.log("Attempting to select winner")
    console.log("ACTUAL ID: ", request.data.payload);
    const listingId = request.data.payload;
    const db = admin.firestore();
    const listingDocument = db.collection('Listings').doc(listingId);
    const listingSnapshot = await listingDocument.get();
    //Create notification to tell user they have won:
    let listingName = "";
    let image = "";
    let hostID = "";
    //Recovers information from snapshot
    const listingData = listingSnapshot.data();
    if (listingData) {
        listingName = listingData.Name;
        image = listingData.PrimaryImage;
        hostID = listingData.HostID;
    } else {
        console.log('No data in document!');
    }

    const ticketsCollection = listingDocument.collection('Tickets');
    const ticketsSnapshot = await ticketsCollection.get();
    let nonWinningUsers = new Set<string>(); //Array of our users who are interested (watching or have tickets) but did not win

    //TODO Add watchers to nonWinningUsers array (if winner inside, will be removed later) <- need to implement watchers first!

    // Check if this document exists (i.e. hasn't been deleted)
    if (ticketsSnapshot.empty) {
        console.log('User has no tickets');
        //TODO send notification saying sorry, your item did not sell, or something along those lines
        createNotification(db, hostID, "Sorry, no one bought any tickets.", image, listingId, listingName);

    } else { // Select winner for current auction
        let ticketArray: string[] = []; //Array to contain a user for every ticket they own (i.e. a user with 5 tickets in the array 5 times)
        
        // We add an individual value into our array for all tickets, to randomly select one after
        ticketsSnapshot.forEach((ticketDoc) => {
            const ticketData = ticketDoc.data();
            nonWinningUsers.add(ticketDoc.id);
            for (let i = 0; i < ticketData.TicketNum; i++) {
                ticketArray.push(ticketDoc.id);
            }
            
        });

        //Selects the winning ticket at random
        const winner = ticketArray[Math.floor(Math.random() * ticketArray.length)];
        await listingDocument.update({Winner: winner});
        nonWinningUsers.delete(winner); //Removes the winner from the nonWinningUsers set
        console.log("The winner is: ", winner);
        createNotification(db, winner, "Congratulations, you have won, please add your address.", image, listingId, listingName);


        //TODO Send notification to item host
        createNotification(db, hostID, "Congratulations, your item has a winner. Awaiting shipping address.", image, listingId, listingName);

    }

    //Now we want to loop through to all users interested in this item that didn't win and notify them they were unsuccessful
    for (let user of nonWinningUsers) {
        createNotification(db, user, "Sorry, you didn't win this item. Better luck next time!", image, listingId, listingName);
    }
});

//Create a new notification for the user under 'Notificaitons' collection AND send push notification to user
async function createNotification(db: admin.firestore.Firestore,userId: string, description: string, image: string, listingId: string, listingName: string){
    const userDataDocument = db.collection('UserData').doc(userId);
    
    const notificationEntry = {
        ListingName: listingName,
        ListingID: listingId,
        Image: image,
        Description: description,
    }
    //Get the current time in milliseconds to set the notification document ID
    const currentTimeInMilliseconds = Date.now().toString();
    userDataDocument.collection('Notifications').doc(currentTimeInMilliseconds).set(notificationEntry).then(() => {
        console.log('New notification successfully written!');
    }).catch((error) => {
        console.error('Error writing new notification: ', error);
    });
    
    //Retrieve users notification token for push notifications:
    const userDoc = await userDataDocument.get();
    const notificationToken = userDoc.data()?.NotificationToken;
    if(notificationToken){
        console.log("Preparing push notification");
        const pushNotification = {
            notification: {
                title: listingName,
                body: description,
            },
            apns: { //Apple handles images differently
                payload: {
                    aps: {
                        alert: {
                            title: listingName,
                            body: description,
                        },
                        'mutable-content': 1,
                    },
                    'media-url': image,
                },
            },
            android: {
                notification: {
                    imageUrl: image
                }
            },
            token: notificationToken
        };
        //Send push notification to device
        await admin.messaging().send(pushNotification);
        console.log("push notification sent");
    }
}
exports.addPushNotification = onCall({region: "europe-west2"}, (request : any) => {
    // Message text passed from the client.
    //const text = request.data.text;
    // Authentication / user information is automatically added to the request.
    //const uid = request.auth.uid;
    //const name = request.auth.token.name || null;
    //const picture = request.auth.token.picture || null;
    //const email = request.auth.token.email || null;
    const db = admin.firestore();
    console.log("Message recieved loud and clear");
    console.log(request.data)

    createNotification(db, request.data.userID, request.data.description, request.data.imageUrl, request.data.listingID, request.data.notificationName);

});
exports.listingCreated = onDocumentCreated({document: "Listings/{docId}",region: "europe-west2"}, async (event) => {
    const snapshot = event.data;
    
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }
    console.log("Document Creation Noticed");
    //Gets current date + 10 seconds
    const endDate = snapshot.data().EndDate;
    // Update the document with the new 'EndDate'

    const endDateJS = endDate.toDate();
    console.log("JS Enddate: ", endDateJS);
    const documentId = snapshot.id;
    console.log("Document ID is: ", documentId);
    const functionName = "selectWinnerQueue";
    const queue = getFunctions().taskQueue(functionName);
    //const endDate = new Date(new Date().getTime() + 10000);
    const targetUri = await getFunctionUrl(functionName);
    console.log("targetUri is", targetUri);
    const payload = documentId;
    console.log("Payload is: ", payload); // Log the payload

    const enqueuePromise = queue.enqueue({payload}, { //Add user ID inside curly braces for future
        uri: targetUri,
        scheduleTime: endDateJS,
    });
    await enqueuePromise;
    console.log("Payload sent");
    return null;
});

exports.queuedTask = onTaskDispatched({region: "europe-west2"},
    {
      retryConfig: { //Retries up to 4 times upon failure with 5 second cooldown
        maxAttempts: 4,
        minBackoffSeconds: 5,
      },
    }, async (req: any) => {
        console.log("Performing action: ", req.id);
    }
);


/**
 * This function was taken from the official firebase documentation [https://firebase.google.com/docs/functions/task-functions?gen=2nd]
 * Get the URL of a given v2 cloud function.
 *
 * @param {string} name the function's name
 * @param {string} location the function's location
 * @return {Promise<string>} The URL of the function
 */
async function getFunctionUrl(name: string, location="europe-west2") {
    if (!auth) {
      auth = new GoogleAuth({
        scopes: "https://www.googleapis.com/auth/cloud-platform",
      });
    }
    const projectId = await auth.getProjectId();
    const url = "https://cloudfunctions.googleapis.com/v2beta/" +
      `projects/${projectId}/locations/${location}/functions/${name}`;
  
    const client = await auth.getClient();
    const res = await client.request({url});
    const uri = res.data?.serviceConfig?.uri;
    if (!uri) {
      throw new Error(`Unable to retreive uri for function at ${url}`);
    }
    return uri;
  }