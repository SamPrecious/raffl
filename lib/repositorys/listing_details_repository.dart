import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/listing_model.dart';


class ListingDetailsRepository extends GetxController {
  static ListingDetailsRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  createListing(ListingModel listingData) async{
    await db.collection("Listings").doc().set(listingData.toFirestore()).whenComplete(
          () => print("Listing creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  //Adds tickets for given user
  buyTickets(String documentID, int ticketAmount) async {
    //TODO Check if user has any tickets, if so, update, if not create new
    String uid = FirebaseAuth.instance.currentUser!.uid;
    int ticketNum = await getTickets(documentID);
    if(ticketNum != 0){
      updateTicketNum(documentID, ticketAmount, uid);
    }
    else{
      createTicketNum(documentID, ticketAmount, uid);
    }
    updateTicketsSold(documentID, ticketAmount);

    return(ticketNum + ticketAmount);
  }

  incrementViews(String documentID) async {
    await db.collection("Listings").doc(documentID).update({"Views": FieldValue.increment(1)})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  modifyWatchers(String documentID, bool userIsWatching) async {
    int toAdd = 1;
    print("To inc or not to inc");
    if(!userIsWatching){
      //If user is no longer watching, remove 1
      toAdd = -1;
      print("Decrementing UserWatching");
    }
    await db.collection("Listings").doc(documentID).update({"UsersWatching": FieldValue.increment(toAdd)})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  updateTicketsSold(String documentID, int ticketAmount) async{
    await db.collection("Listings").doc(documentID).update({"TicketsSold": FieldValue.increment(ticketAmount)})
        .catchError((error, stackTrace) {
          throw Exception(error.toString());
        });
  }

  createTicketNum(String documentID, int ticketAmount, String uid) async {
    await db.collection("Listings").doc(documentID)
        .collection("Tickets").doc(uid).set({'TicketNum': ticketAmount}).whenComplete(
          () => print("ticket num creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
    //New user has bought a ticket, thus, users interested increments by 1
    print("Updating users interested");
    await db.collection("Listings").doc(documentID).update({"UsersInterested": FieldValue.increment(1)})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  updateTicketNum(String documentID, int ticketAmount, String uid) async {
    await db.collection("Listings").doc(documentID)
        .collection("Tickets").doc(uid)
        .update({"TicketNum": FieldValue.increment(ticketAmount)});
  }



  getTickets(String documentID) async {
    final snapshot = await db.collection("Listings").doc(documentID)
        .collection("Tickets").doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    int ticketNum = 0;
    if(snapshot.exists){
      ticketNum = snapshot.data()!['TicketNum'];
    }
    return ticketNum;
  }


  Future<ListingModel> getListing(String documentID) async {
    print("Retrieving listing with ID: $documentID");
    final snapshot = await db.collection("Listings").where(FieldPath.documentId, isEqualTo: documentID).get();
    print("Documents found: ${snapshot.docs.length}");
    print("Snapshot is $snapshot");
    int ticketsOwned = await getTickets(documentID);
    final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e, ticketsOwned)).single;
    print("Listing found");


    return listing;
  }


}