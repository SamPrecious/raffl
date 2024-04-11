import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/address_model.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/models/shipping_details_model.dart';
import 'package:raffl/repositorys/user_data_repository.dart';


class ListingRepository extends GetxController {
  static ListingRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  createListing(ListingModel listingData) async{
    await db.collection("Listings").doc().set(listingData.toFirestore()).whenComplete(
          () => print("Listing creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  addAddress(String listingID, AddressModel address) async{

    await db.collection("Listings").doc(listingID).update({"Address": address.toFirestore()})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  markReceived(String listingID) async{
    await db.collection("Listings").doc(listingID).update({"ItemReceived": true})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  addShippingDetails(String listingID, ShippingDetailsModel shippingDetails) async{
    await db.collection("Listings").doc(listingID).update({"ShippingDetails": shippingDetails.toFirestore()})
        .catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  getAddress(String listingID) async{
    final snapshot = await db.collection("Listings").doc(listingID).get();
    final address = snapshot.data()?['Address'];
    if (address != null) {
      print("Non-model: ${address}");
      final addressModel = AddressModel.fromFirestore(address);
      print("Address model: {$addressModel}");
      return addressModel;
    }
  }

  //Adds tickets for given user
  buyTickets(String documentID, int ticketAmount, int ticketPrice) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    //We make the transaction atomic so it is all or nothing
    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final userDataRepository = Get.put(UserDataRepository());
      bool transactionSuccess = await userDataRepository.subtractCredits(transaction, (ticketAmount * ticketPrice));
      if(transactionSuccess){
        print("Transaction successful, withdrawing now");
        int ticketNum = await getTickets(documentID);
        print("Our ticket number is: ${ticketNum}");
        if(ticketNum != 0){
          print("We are updating the ticket num");
          updateTicketNum(transaction, documentID, ticketAmount, uid);
        }
        else{
          print("We are creating the ticket num");
          createTicketNum(transaction, documentID, ticketAmount, uid);
        }
        updateTicketsSold(transaction, documentID, ticketAmount);
        return true;
      }else{
        print("Transaction unsuccessful, update funds");
      }
      return false;

    });
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

  updateTicketsSold(Transaction transaction, String documentID, int ticketAmount) async{
    final listingDoc = FirebaseFirestore.instance.collection('Listings').doc(documentID);
    await transaction.update(listingDoc, {"TicketsSold": FieldValue.increment(ticketAmount)});
  }

  createTicketNum(Transaction transaction, String documentID, int ticketAmount, String uid) async {
    final listingDoc = FirebaseFirestore.instance.collection('Listings').doc(documentID);
    await transaction.set(listingDoc.collection('Tickets').doc(uid), {'TicketNum': ticketAmount});
    //New user has bought a ticket, which means they are interested and thus this counter goes up
    print("We will now increment users");
    await listingDoc.update({'UsersInterested': FieldValue.increment(1)});
    //await transaction.update(listingDoc, {'UsersInterested': FieldValue.increment(1)}); For unknown reasons, this doesn't work when it is transaction based, but its not that important
  }

  updateTicketNum(Transaction transaction, String documentID, int ticketAmount, String uid) async {
    final listingDoc = FirebaseFirestore.instance.collection('Listings').doc(documentID).collection("Tickets").doc(uid);
    await transaction.update(listingDoc, {"TicketNum": FieldValue.increment(ticketAmount)});
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

  Future<List<ListingModel>> getSelling(String userID, bool ongoing) async {
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    print("Current timestamp ${timestamp}");
    Filter dateFilter;
    if (ongoing) {
      dateFilter = Filter('EndDate', isGreaterThan: timestamp);
    }else{
      dateFilter = Filter('EndDate', isLessThanOrEqualTo: timestamp);
    }

    //AlgoliaQuery query = algolia.instance.index('listings_index').query("");
    final snapshot = await db.collection("Listings").where(Filter.and(Filter('HostID', isEqualTo: userID),dateFilter)).get(); //Filter('HostID', isEqualTo: userID)
    final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e, 0)).toList();
    return listing;
  }

  Future<ListingModel?> selectListing(List<ListingModel> listings, List<String> blacklist) async {

    //We manually filter out listings on our blacklist, as it doesn't seem to like Querying on the documentID AND the other filters at the same time 'An error occured while parsing query arguments'
    listings = listings.where((listing) => !blacklist.contains(listing.documentID)).toList();

    print("Filtered listings: ${listings}");
    if (!listings.isEmpty) {
      // Pick a random listing
      final random = Random();
      final randomListing = listings[random.nextInt(listings.length)];
      return randomListing;
    }
    return null;
  }

  Future<ListingModel?> getRecommendedListingByTag(String tag, List<String> blacklist) async {
    Filter hostFilter = Filter("HostID", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid);
    Filter tagsFilter = Filter("Tags", arrayContains: tag);
    final snapshot = await db.collection("Listings").where(Filter.and(hostFilter, tagsFilter)).get();
    List<ListingModel> listings = snapshot.docs.map((e) => ListingModel.fromFirestore(e, 0)).toList();
    if(listings.isNotEmpty){
      return await selectListing(listings, blacklist);
    }
    return null;
  }

  //If we do not have enough recommended listings from our tags, we randomly select the rest
  Future<ListingModel?> getRecommendListingRandom(List<String> blacklist) async {
    Filter hostFilter = Filter("HostID", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid);
    final snapshot = await db.collection("Listings").where(hostFilter).get();

    List<ListingModel> listings = snapshot.docs.map((e) => ListingModel.fromFirestore(e, 0)).toList();
    if(listings.isNotEmpty){
      return await selectListing(listings, blacklist);
    }
    return null;
  }

  Future<List<ListingModel>> getWins(String userID) async {
    //AlgoliaQuery query = algolia.instance.index('listings_index').query("");
    final snapshot = await db.collection("Listings").where('Winner', isEqualTo: userID).get();
    final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e, 0)).toList();
    return listing;
  }

  Future<List<ListingModel>> getDocuments(List<String> watching) async {
    List<ListingModel> watchingDocuments = [];

    for (String documentID in watching){
      final snapshot = await db.collection("Listings").where(FieldPath.documentId, isEqualTo: documentID).get();
      final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e, 0)).single;
      watchingDocuments.add(listing);
    }
    return watchingDocuments;
  }


}