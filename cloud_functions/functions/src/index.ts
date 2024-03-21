//import * as functionsV1 from 'firebase-functions/v1';
//import * as functionsV2 from 'firebase-functions/v2';
import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';
admin.initializeApp();
//const db = admin.firestore();
import {
    //onDocumentWritten,
    onDocumentCreated,
    //onDocumentUpdated,
    //onDocumentDeleted,
  } from "firebase-functions/v2/firestore";



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
});


exports.selectWinner = functions.https.onRequest(async (request, response) => {
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

    response.json({ message: "Name retrieved" });

});


/*
exports.onListingCreate = functions.region('europe-west2').firestore
    .document('Listings/{listingId}')
    .onCreate(async (snap, context) => {
        // Access the newly created document
        console.log('testttttttttttt');
        const newData = snap.data();

        // Perform operations such as sending notifications, updating counters, etc.
        console.log('New listing added:', newData);

        // Update the 'Name' field to 'changedName'
        //await snap.ref.update({ Name: 'changedName' });

        console.log('Name field updated to "changedName"');

        // Example: Return a Promise if performing asynchronous operations
        return Promise.resolve();
    }
);
*/

/*
exports.addListing = functions.region('europe-west2').https.onRequest(async (req, res) => {
        const docRef = db.collection('Listings').doc(); // Auto-generates a document ID
    
        console.log("setting name field");
        await docRef.set({
          Name: 'testname' // Sets the 'Name' field of the document
        });
    
        console.log("bosh");
        res.status(200).send({message: 'Done'}); // Sends a JSON response back to the client
    }
);*/
/*
export const createListing = onDocumentCreated("Listings/{docId}", (event) => {
    console.log("-------------------------------------------------------");
    const snapshot = event.data;
    
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }

    console.log("Document Creation Noticed");
    return null; //Return null to indicate function is complete
 });
 /*


/*

*/






/*
//const functions = require('firebase-functions');
export const createListing = functionsV1.firestore
    .document('Listings/{docId}')
    .onCreate((snap: admin.firestore.DocumentSnapshot, context: functionsV1.EventContext) => {

      console.log("-------------------------------------------------------");
      console.log("Document Creation Noticed");

    });

*/
/*



export const createListing = onDocumentCreated("Listings/{docId}", (event) => {
    console.log("-------------------------------------------------------");
    const snapshot = event.data;
    
    if (!snapshot) {
        console.log("No data associated with the event");
        return;
    }

    console.log("Document Creation Noticed");
    return null; //Return null to indicate function is complete
 });
 */



//npm run build:watch watches for function changes and automatically updates for us
//npm run serve for emulator (replace serve with dev for debugger)
//npx firebase emulators:start --only firestore for firestore console
/*
type Sku = {Name: string};
export const newsku = functionsV1.firestore.document('Listings/{sku}')
    .onCreate(snapshot => {
        console.log(`test`);
        const data = snapshot.data() as Sku;
        const name = data.Name;
        const promise = console.log(`A new listing named ${name} was created`); //Promise lets us know async function has completed
        return promise;
    });
type Indexable = {[key: string]: any};
export const hellworld = functionsV2.https.onRequest((request, response) => {
    debugger;
    const name = request.params[0];
    const items: Indexable = {lamp: 'This es lamp', chair: 'Now chair'};
    const message = items[name]
    response.send(`<h2>${message}</h2>`);

});
*/