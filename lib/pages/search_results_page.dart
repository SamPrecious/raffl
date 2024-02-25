import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
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
            Expanded(
              child: FutureBuilder(
                //                future: algoliaListingsController.searchListings(widget.searchInput),
                  future: algoliaListingsController.getSearchResults(widget.searchInput),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done) {
                      if(snapshot.hasData) {
                        List<ListingModel> outputList = snapshot.data as List<ListingModel>;
                        outputList.forEach((result) =>
                        print(result.toString()));
                        print(outputList);
                        int outputLength = outputList.length;
                        print("output length is $outputLength");
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Container(
                            clipBehavior: Clip.hardEdge,
                            //Using foregroundDecoration prevents content overlapping borders
                            foregroundDecoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                left: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                right: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
              

                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: outputLength,
                                    itemBuilder: (context, index){
                                      ListingModel item = outputList[index];
                                      String documentID = item.getDocumentID();
                                      String name = item.getName();
                                      int endDate = item.getDate();
                                      String imageUrl = item.getPrimaryImageURL();
                                      return GestureDetector(
                                        //Constructs 'ListingResultWidget' for each separate listing
                                          child: ListingResultWidget(
                                                  name: name,
                                                  endDate: endDate,
                                                  primaryImageUrl: imageUrl
              
                                          ),
                                          onTap: () => AutoRouter.of(context).push(ViewListingRoute(documentID: documentID))
                                      );
                                    }
                                ),

                          ),
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
            ),
          ]
        ),
      )
    );
  }
}