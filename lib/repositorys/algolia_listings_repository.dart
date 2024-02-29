import 'package:algolia/algolia.dart';
import 'package:get/get.dart';
import 'package:raffl/models/listing_model.dart';

class AlgoliaListingsRepository extends GetxController {
  static AlgoliaListingsRepository get instance => Get.find();

  final Algolia algolia =
      Algolia.init(
        applicationId: 'QI3CDM6R1I',
        apiKey: 'ecbba92673de298d6229229af5414a68'
      );


  Future<List<AlgoliaObjectSnapshot>> searchListings(String searchQuery) async {
    final query = algolia.instance.index('listings_index').query(searchQuery);
    final snapshot = await query.getObjects();
    return snapshot.hits;
  }


  Future<List<ListingModel>> getSearchResults(String searchQuery) async {
    final query = algolia.instance.index('listings_index').query(searchQuery);
    final snapshot = await query.getObjects();
    final searchResults = snapshot.hits.map((e) => ListingModel.fromAlgolia(e)).toList();
    return searchResults;
  }



}