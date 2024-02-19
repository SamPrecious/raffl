import 'package:get/get.dart';
import '../repositorys/algolia_listings_repository.dart';

class AlgoliaListingsController extends GetxController{

  static AlgoliaListingsController get instance => Get.find();

  final algoliaListingsRepository = Get.put(AlgoliaListingsRepository());


  searchListings(String searchQuery){ //String searchQuery
    return algoliaListingsRepository.searchListings(searchQuery);
  }

  getSearchResults(String searchQuery){
    print("Retrieving search results");
    return algoliaListingsRepository.getSearchResults(searchQuery);
  }
}