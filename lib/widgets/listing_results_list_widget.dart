import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/listing_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/widgets/listing_result_widget.dart';

class ListingResultsListWidget extends StatefulWidget {
  final Future? listingFuture;
  final TextEditingController searchController;
  ListingResultsListWidget({this.listingFuture, required this.searchController});

  @override
  _ListingResultsListWidgetState createState() => _ListingResultsListWidgetState();
}

class _ListingResultsListWidgetState extends State<ListingResultsListWidget> {

  ListingController listingController = Get.put(ListingController());
  List<ListingModel> outputList = [];
  List<ListingModel> filteredList = [];




  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
          future: widget.listingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ListingModel> data = snapshot.data as List<ListingModel>;
                if(data != outputList){
                  outputList = data;
                  filteredList = List.from(outputList);
                }

                int outputLength = filteredList.length;
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
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
                              shrinkWrap: true,
                              // This ensures that the ListView only occupies the space it needs
                              cacheExtent: 9999,
                              //Having a relatively large cache gives us longer before reloading images
                              padding: EdgeInsets.zero,
                              itemCount: outputLength,
                              itemBuilder: (context, index) {
                                ListingModel item = filteredList[index];
                                String documentID = item.getDocumentID();
                                String name = item.getName();
                                int endDate = item.getDate();
                                int ticketsSold = item.getTicketsSold();
                                int usersInterested =
                                item.getUsersInterested();
                                int views = item.getViews();
                                int ticketPrice = item.getTicketPrice();
                                String imageUrl =
                                item.getPrimaryImageURL();
                                return GestureDetector(
                                  //Constructs 'ListingResultWidget' for each separate listing
                                    child: ListingResultWidget(
                                        name: name,
                                        endDate: endDate,
                                        primaryImageUrl: imageUrl,
                                        ticketsSold: ticketsSold,
                                        usersInterested: usersInterested,
                                        views: views,
                                        ticketPrice: ticketPrice),
                                    onTap: () => AutoRouter.of(context)
                                        .push(ViewListingRoute(
                                        documentID: documentID)));
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    Text("No Data"),
                  ],
                );
              }
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: Text("Error, no data found"));
            }
          }),
    );
  }
}