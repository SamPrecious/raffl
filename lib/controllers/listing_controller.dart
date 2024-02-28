import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/repositorys/image_repository.dart';
import '../models/user_data_model.dart';
import '../repositorys/listing_details_repository.dart';
import 'package:get/get.dart';


class ListingController extends GetxController{

  final listingDetailsRepository = Get.put(ListingDetailsRepository());
  final listingImageRepository = Get.put(ImageRepository());

  Future<void> createListing(ListingModel listing) async{
    await listingDetailsRepository.createListing(listing);
  }

  Future<String> uploadImage(XFile file, String fileName) async{
    String imageUrl = await listingImageRepository.uploadImage(file, fileName);
    return imageUrl;
  }

  getListing(String documentID){
    return listingDetailsRepository.getListing(documentID);
  }

  getTickets(String documentID) async{
    return await listingDetailsRepository.getTickets(documentID);
  }

  updateTickets(String documentID, int ticketAmount) async{
    await listingDetailsRepository.buyTickets(documentID, ticketAmount);
  }

}