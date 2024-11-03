import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/repositorys/user_data_repository.dart';
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



  getWins(String userID){
    return algoliaListingsRepository.getWins(userID);
  }

  getWatching(String userID) async {
    final userDataRepository = UserDataRepository();
    List<String>? watching = await userDataRepository.getWatching(userID);
    if(watching != null){
      return algoliaListingsRepository.getWatching(watching);
    }
    return null;
  }

}