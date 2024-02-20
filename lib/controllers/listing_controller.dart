import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:raffl/models/listing_model.dart';
import '../models/user_data_model.dart';
import '../repositorys/listing_repository.dart';
import 'package:get/get.dart';


class ListingController extends GetxController{

  final listingRepository = Get.put(ListingRepository());

  Future<void> createListing(ListingModel listing) async{
    await listingRepository.createListing(listing);
  }

  getListing(String documentID){
    return listingRepository.getListing(documentID);
  }

}