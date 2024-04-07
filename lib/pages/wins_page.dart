import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/algolia_listings_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:raffl/widgets/title_header_widget.dart';

@RoutePage()
class WinsPage extends StatefulWidget {
  final String searchInput;

  WinsPage(
      {super.key,
        required this.searchInput});

  @override
  State<WinsPage> createState() => _WinsPageState();
}

class _WinsPageState extends State<WinsPage> {
  final filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? userID = FirebaseAuth.instance.currentUser!.uid;

    //filterController.text = widget.sortInput ?? 'Sort (Default)';
    //RangeValues currentPriceRange = widget.priceRange ?? RangeValues(0, 50);

    //bool soldItemCheckbox = widget.soldItems;
    AlgoliaListingsController algoliaListingsController =
    Get.put(AlgoliaListingsController());

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
            child: Column(
              children: [
                SearchBar(
                  onSubmitted: (query) {
                    //TODO Implement
                  },
                  leading: const Icon(Icons.search),
                ),
              ],
            ),
          ),
        Center(
          child: Text("Wins",
              style: TextStyle(
                color: secondaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )
          ),
        ),
          Expanded(
            child: FutureBuilder(
                future: algoliaListingsController.getWins(
                    widget.searchInput,
                    userID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<ListingModel> outputList =
                      snapshot.data as List<ListingModel>;
                      int outputLength = outputList.length;
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
                                      ListingModel item = outputList[index];
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
          ),
        ]),
      ),
      resizeToAvoidBottomInset:
      false, //Avoids whitespace above keyboard blocking content
    );
  }
}