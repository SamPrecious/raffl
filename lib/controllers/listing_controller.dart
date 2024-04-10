import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raffl/models/address_model.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/models/shipping_details_model.dart';
import 'package:raffl/repositorys/image_repository.dart';
import 'package:raffl/repositorys/user_data_repository.dart';
import '../models/user_data_model.dart';
import '../repositorys/listing_repository.dart';
import 'package:get/get.dart';


class ListingController extends GetxController{

  final listingRepository = Get.put(ListingRepository());
  final listingImageRepository = Get.put(ImageRepository());

  Future<void> createListing(ListingModel listing) async{
    await listingRepository.createListing(listing);
    //TODO Create cloud function when listing is created. Verify that this is the place to put it
    //TODO Add listing to user profile when created as well. Faster requests at the cost of duplicating data
    
  }

  Future<void> addAddress(String listingID, AddressModel address) async {
    await listingRepository.addAddress(listingID, address);
  }

  Future<void> markReceived(String listingID) async{
    await listingRepository.markReceived(listingID);
  }

  Future<void> addShippingDetails(String listingID, ShippingDetailsModel shippingDetails) async {
    await listingRepository.addShippingDetails(listingID, shippingDetails);
  }

  Future<String> uploadImage(XFile file, String fileName) async{
    String imageUrl = await listingImageRepository.uploadImage(file, fileName);
    return imageUrl;
  }

  getListing(String documentID){
    return listingRepository.getListing(documentID);
  }

  getWins(String userID){
    return listingRepository.getWins(userID);
  }

  getWatching() async {
    final userDataRepository = UserDataRepository();
    List<String>? watching = await userDataRepository.getWatching(FirebaseAuth.instance.currentUser!.uid);
    if(watching != null){
      return listingRepository.getDocuments(watching);
    }
    return null;
  }

  getDocuments(List<String>? recentlyViewed) async {
    if(recentlyViewed != null){
      return listingRepository.getDocuments(recentlyViewed);
    }
    return null;
  }
  getRecentlyViewed(UserDataRepository userDataRepository) async {
    List<String>? recentlyViewed = await userDataRepository.getRecentlyViewed();
    return recentlyViewed;
  }


  Future<List<List<ListingModel>>> getHomepageResults() async{
    final userDataRepository = UserDataRepository();
    List<String>? recentlyViewed = await getRecentlyViewed(userDataRepository);

    List<ListingModel> recentlyViewedResults = await getDocuments(recentlyViewed);
    //List<ListingModel> recommendedResults = await getDocuments(recentlyViewed);


    List<ListingModel> recommendedResults = await userDataRepository.getRecommendations(recentlyViewed);
    return [recentlyViewedResults, recommendedResults];
  }

  getSelling(String userID, bool ongoing){
    return listingRepository.getSelling(userID, ongoing);
  }

  getAddress(String listingID) async{
    return await listingRepository.getAddress(listingID);
  }

  getTickets(String documentID) async{
    return await listingRepository.getTickets(documentID);
  }

  buyTickets(String documentID, int ticketAmount, int ticketPrice) async{
    return await listingRepository.buyTickets(documentID, ticketAmount, ticketPrice);
  }

  incrementViews(String documentID) async{
    await listingRepository.incrementViews(documentID);
  }

  modifyWatchers(String documentID, bool userIsWatching) async{
    await listingRepository.modifyWatchers(documentID, userIsWatching);
  }

}