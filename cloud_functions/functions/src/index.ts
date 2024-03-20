import * as functionsV2 from 'firebase-functions/v2';


type Sku = { EndDate: number };
export const newListing = functionsV2.firestore.document('/Listings/{sku}')
    .onCreate(snapshot => {
        const data = snapshot.data();
        const endDateTimestamp = data?.EndDate as firebase.firestore.Timestamp;
        const endDate = endDateTimestamp.toDate().getTime();
        
        // Now you can use endDate as a number
    }
);