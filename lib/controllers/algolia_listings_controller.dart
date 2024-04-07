import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositorys/algolia_listings_repository.dart';

class AlgoliaListingsController extends GetxController{

  static AlgoliaListingsController get instance => Get.find();

  final algoliaListingsRepository = Get.put(AlgoliaListingsRepository());


  searchListings(String searchQuery){ //String searchQuery
    return algoliaListingsRepository.searchListings(searchQuery);
  }

  getSearchResults(String searchQuery, String? optionalSort, bool soldItems, RangeValues priceRange){
    return algoliaListingsRepository.getSearchResults(searchQuery, optionalSort, soldItems, priceRange);
  }

  getWins(String searchQuery, String userID){
    return algoliaListingsRepository.getWins(searchQuery, userID);
  }

}