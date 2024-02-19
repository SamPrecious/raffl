import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:raffl/models/search_results_model.dart';


class ListingsRepository extends GetxController {
  static ListingsRepository get instance => Get.find();
  final db = FirebaseFirestore.instance;


  Future<ListingModel> getListing(String documentID) async {
    print("Retrieving listing with ID: $documentID");
    final snapshot = await db.collection("Listings").where(FieldPath.documentId, isEqualTo: documentID).get();
    print("Documents found: ${snapshot.docs.length}");
    final listing = snapshot.docs.map((e) => ListingModel.fromFirestore(e)).single;
    print("Listing found");
    return listing;
  }


}