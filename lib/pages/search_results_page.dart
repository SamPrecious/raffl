import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/models/search_results_model.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import '../controllers/algolia_listings_controller.dart';

@RoutePage()
class SearchResultsPage extends StatefulWidget {
  final String searchInput; // Add this line to accept the initial value

  const SearchResultsPage({super.key, required this.searchInput});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}


class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  Widget build(BuildContext context) {
    AlgoliaListingsController algoliaListingsController = Get.put(AlgoliaListingsController());

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(widget.searchInput),
            FutureBuilder(
              //                future: algoliaListingsController.searchListings(widget.searchInput),
                future: algoliaListingsController.getSearchResults(widget.searchInput),
                builder: (context, snapshot){
                  if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasData) {
                      print("HAS DATA NOW");
                      List<SearchResultsModel> outputList = snapshot.data as List<SearchResultsModel>;
                      print("------------------------");
                      outputList.forEach((result) =>
                      print(result.toString()));
                      print(outputList);
                      print("------------------------");
                      int outputLength = outputList.length;
                      print("output length is $outputLength");
                      return Column(
                        children: [
                          Text("Has Data"),
                          SizedBox(
                            height: 640,
                            child: ListView.builder(
                              itemCount: outputLength,
                              itemBuilder: (context, index){
                                SearchResultsModel item = outputList[index];
                                String name = item.getName();
                                int endDate = item.getDate();
                                return ListingResultWidget(name: name,endDate: endDate);
                                print("ITEM TO STRING");
                                print(item.getName());
                                return ListTile(
                                  title: Text(item.toString()),
                                );
                              }
                            ),
                          ),

                          /*
                          Expanded( // Wrap ListView.builder in an Expanded widget
                            child: ListView.builder(
                              itemCount: outputLength,
                              itemBuilder: (BuildContext context, int index) {
                                SearchResultsModel item = outputList[index];
                                return ListTile(
                                  title: Text(item.toString()),
                                );
                              },
                            ),
                          ),*/
                        ],
                      );
                    }
                    else{
                      return Column(
                        children: [
                          Text("No Data"),
                        ],
                      );
                    }

                  }else if(snapshot.hasError){
                    return Center(child: Text(snapshot.error.toString()));
                  }else{
                    return Center(child: Text("Error, no data found"));
                  }

                }),
          ]
        ),
      )
    );
  }
}