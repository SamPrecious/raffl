//import * as functionsV1 from 'firebase-functions/v1';
//import * as functionsV2 from 'firebase-functions/v2';
//import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
admin.initializeApp();
//const db = admin.firestore();
import {
    //onDocumentWritten,
    onDocumentCreated,
    //onDocumentUpdated,
    //onDocumentDeleted,
  } from "firebase-functions/v2/firestore";

// Dependencies for task queue functions.
const {onTaskDispatched} = require("firebase-functions/v2/tasks");
const {onRequest} = require("firebase-functions/v2/https");
const {getFunctions} = require("firebase-admin/functions");

// Dependencies for image backup.
const {GoogleAuth} = require("google-auth-library");
let auth = new GoogleAuth({
    scopes: 'https://www.googleapis.com/auth/cloud-platform',
  });
  

//Queues the select winner task for the endDate of our raffle auction
exports.enqueueSelectedWinner = onRequest({region: "europe-west2"},
    async (request: any, response: any) => {
        const functionName = "selectWinnerQueue";
        const queue = getFunctions().taskQueue(functionName);
        const endDate = new Date(new Date().getTime() + 10000);
        const targetUri = await getFunctionUrl(functionName);
        console.log("targetUri is", targetUri);
        const payload = '1234';
        console.log("Payload is: ", payload); // Log the payload

        const enqueuePromise = queue.enqueue({payload}, { //Add user ID inside curly braces for future
              uri: targetUri,
              scheduleTime: endDate,
        });
        await enqueuePromise;
        console.log("Payload sent");
        response.sendStatus(200);
    }
);

//This function is automatically invoked when a listing timestamp ends, and will select a winner at random
exports.selectWinnerQueue = onTaskDispatched({region: "europe-west2"}, async (request: any) => {
    //TODO Change listingID to function input when done with testing
    console.log("Attempting to select winner")
    console.log("ACTUAL ID: ", request.data.payload);
    const listingId = '1234';
    console.log("Request is ", request);
    const db = admin.firestore();
    const listingDocument = db.collection('Listings').doc(listingId);
    //const testD = request.id; // Access the payload as a string
    
    //console.log("ID is ->", testD);
    //await listingDocument.update({Winner: "testVal"})
        
    const ticketsCollection = listingDocument.collection('Tickets');
    const ticketsSnapshot = await ticketsCollection.get();

    // Check if this document exists (i.e. hasn't been deleted)
    if (ticketsSnapshot.empty) {
        console.log('User has no tickets');
    } else {
        let ticketArray: string[] = [];


        // We add an individual value into our array for all tickets, to randomly select one after
        ticketsSnapshot.forEach((ticketDoc) => {
            const ticketData = ticketDoc.data();
            for (let i = 0; i < ticketData.TicketNum; i++) {
                ticketArray.push(ticketDoc.id);
            }
            
        });
        //Selects the winning ticket at random
        const winner = ticketArray[Math.floor(Math.random() * ticketArray.length)]
        await listingDocument.update({Winner: winner})
        console.log("The winner is: ", winner)
    }
});

exports.listingCreated = onDocumentCreated({document: "Listings/{docId}",region: "europe-west2"}, async (event) => {
    const snapshot = event.data;
    
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }
    console.log("Document Creation Noticed");
    //Gets current date + 10 seconds
    const newEndDate = admin.firestore.Timestamp.fromMillis(admin.firestore.Timestamp.now().toMillis() + 10 * 1000);

    // Update the document with the new 'EndDate'
    await snapshot.ref.update({ TestEndDate: newEndDate });

    const endDateJS = newEndDate.toDate();

    //Set winner to be selected in 10 seconds
    const functionName = "selectWinnerQueue";
    const queue = getFunctions().taskQueue(functionName);
    const payload = {
        id: '1234',
    }
    //Schedules queuedTask function at endDate
    queue.enqueue(payload, {scheduleTime: endDateJS});
    console.log("Task queued");
    return null; //Return null to indicate function is complete
});


exports.queuedTask = onTaskDispatched({region: "europe-west2"},
    {
      retryConfig: { //Retries up to 4 times upon failure with 5 second cooldown
        maxAttempts: 4,
        minBackoffSeconds: 5,
      },
    }, async (req: any) => {
        console.log("Performing action: ", req.id);
    });





/*
exports.listingCreated = onDocumentCreated({document: "Listings/{docId}",region: "europe-west2"}, async (event) => {
    console.log("-------------------------------------------------------");
    const snapshot = event.data;
    
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }

    console.log("Document Creation Noticed");

    // Get the 'EndDate' field from the document
    const endDate = snapshot.get('EndDate');
    if (!endDate) {
        console.log("No EndDate field in the document");
        return;
    }

    // Ensure 'EndDate' is a Timestamp
    if (!(endDate instanceof admin.firestore.Timestamp)) {
        console.log("EndDate is not a Timestamp");
        return;
    }
    // Add 1 day to 'EndDate'
    const newEndDate = admin.firestore.Timestamp.fromMillis(endDate.toMillis() + 24 * 60 * 60 * 1000);

    // Update the document with the new 'EndDate'
    await snapshot.ref.update({ TestEndDate: newEndDate });

    console.log('Field "EndDate" updated with value 1 day later');

    return null; //Return null to indicate function is complete
});*/



/*
exports.queueTask = functions.https.onRequest(async (request, response) => {
    console.log("test");
    const functionName = "taskFunction"
    const queue = functions.taskQueue(functionName);
});*/
    
//This function is automatically invoked when a listing timestamp ends, and will select a winner at random
exports.selectWinner = onRequest({region: "europe-west2"},async (request: any, response: any) => {
    //TODO Change listingID to function input when done with testing
    const listingId = 1234;

    const db = admin.firestore();
    const listingDocument = db.collection('Listings').doc(listingId.toString());
    const listingDoc = await listingDocument.get();

    // Check if this document exists (i.e. hasn't been deleted)
    if (!listingDoc.exists) {
        console.log('Document no longer exists');
    } else {
        const ticketsCollection = listingDocument.collection('tickets');

        const ticketsSnapshot = await ticketsCollection.get();

        let ticketArray: string[] = [];


        // We add an individual value into our array for all tickets, to randomly select one after
        ticketsSnapshot.forEach((ticketDoc) => {
            const ticketData = ticketDoc.data();
            for (let i = 0; i < ticketData.TicketNum; i++) {
                ticketArray.push(ticketDoc.id);
            }
            
        });
        //Selects the winning ticket at random
        const winner = ticketArray[Math.floor(Math.random() * ticketArray.length)]
        await listingDocument.update({Winner: winner})
        console.log("The winner is: ", winner)
    }
});


/**
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