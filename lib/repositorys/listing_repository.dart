import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raffl/models/listing_model.dart';


class ListingRepository extends GetxController {
  static ListingRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;

  createListing(ListingModel listingData) async{
    //Sets userID to documentID, so we can retrieve documents linked to our users data

    print("Creating new listing");
    await db.collection("Listings").doc().set(listingData.toFirestore()).whenComplete(
          () => print("Listing creation successful"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  Future<ListingModel> getListing(String documentID) async {
    print("Retrieving listing with ID: $documentID");
    final snapshot = await db.collection("Listings").where(FieldPath.documentId, isEqualTo: documentID).get();
    print("Documents found: ${snapshot.docs.length}");
    final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e)).single;
    print("Listing found");
    return listing;
  }


}