import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
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



  Future<List<ListingModel>> getSearchResults(String searchQuery, String? optionalSort, bool soldItems, RangeValues priceRange) async {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    AlgoliaQuery query = algolia.instance.index('listings_index').query(searchQuery);
    // Add price range filter
    print("Price ranges:");
    String filterQuery;
    if(soldItems){
      filterQuery = "EndDate <= ${currentTime}";
    }else{
      filterQuery = "EndDate > ${currentTime}";
    }

    filterQuery += " AND TicketPrice:${priceRange.start.toInt()} TO ${priceRange.end.toInt()}";
    query = query.filters(filterQuery);
    print(query);

    final snapshot = await query.getObjects();
    final searchResults = snapshot.hits.map((e) => ListingModel.fromAlgolia(e)).toList();
    if (optionalSort != null) {
      print("Sorting results with ${optionalSort}");
      if (optionalSort == 'Cheapest Tickets') {
        searchResults.sort((a, b) => a.ticketPrice!.compareTo(b.ticketPrice!));
      } else if (optionalSort == 'Ending Soonest') {
        searchResults.sort((a, b) => a.endDate.compareTo(b.endDate));
      } else if (optionalSort == 'Most Sold') {
        searchResults.sort((a, b) => b.ticketsSold!.compareTo(a.ticketsSold!));
      } else if (optionalSort == 'Most Viewed') {
        searchResults.sort((a, b) => a.views!.compareTo(b.views!));
      }
    }
    return searchResults;
  }

  Future<List<ListingModel>> getWins(String userID) async {

    AlgoliaQuery query = algolia.instance.index('listings_index').query("");
    String filterQuery = "Winner:${userID}";
    query = query.filters(filterQuery);

    final snapshot = await query.getObjects();
    final searchResults = snapshot.hits.map((e) => ListingModel.fromAlgolia(e)).toList();
    return searchResults;
  }


  Future<List<ListingModel>> getWatching(List<String> watching) async {
    AlgoliaQuery query = algolia.instance.index('listings_index').query("");
    String filterQuery = "objectID:${watching[0]}";

    for (var i = 1; i < watching.length; i++) {
      String userID = watching[i];
      filterQuery += " OR objectID:${userID}";
    }
    print(filterQuery);
    query = query.filters(filterQuery);

    final snapshot = await query.getObjects();
    final searchResults = snapshot.hits.map((e) => ListingModel.fromAlgolia(e)).toList();
    return searchResults;
  }



}




