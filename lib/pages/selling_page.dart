import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/algolia_listings_controller.dart';
import 'package:raffl/controllers/listing_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import 'package:raffl/styles/text_styles.dart';

@RoutePage()
class SellingPage extends StatefulWidget {
  final bool ongoing;
  SellingPage({super.key, required this.ongoing});

  @override
  State<SellingPage> createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  final searchController = TextEditingController();
  final filterController = TextEditingController();

  List<ListingModel> outputList = [];
  List<ListingModel> filteredList = [];

  Future? listingFuture;
  ListingController listingController = Get.put(ListingController());

  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    listingFuture =
        listingController.getSelling(FirebaseAuth.instance.currentUser!.uid, widget.ongoing);
  }

  //Filter the list
  onSearchChanged() {
    setState(() {
      filteredList = outputList.where((item) {
        print(
            "Search results: ${item.getName().toLowerCase().contains(searchController.text.toLowerCase())}");
        return item
            .getName()
            .toLowerCase()
            .contains(searchController.text.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.ongoing){
      filterController.text = 'Ongoing';
    }else{
      filterController.text = 'Ended';
    }

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded, size: 30),
                    onPressed: () {
                      print("back");
                      AutoRouter.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        child: Text('List Item'),
                        style: standardButton,
                        onPressed: () {
                          AutoRouter.of(context).push(CreateListingRoute());
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(), // Empty container for the remaining space
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  child: SearchBar(
                    controller: searchController,
                    leading: const Icon(Icons.search),
                  ),
                ),
                DefaultTextStyle(
                  style: myTextStyles.fadedText,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ButtonTheme(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: filterController.text,
                          // Set the initial value
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              //Use searchInput along with Sort value to push a new page
                              print("Currently on: ${filterController.text}");
                              if (filterController.text != newValue) {
                                filterController.text =
                                    newValue; // Update the controller value
                                print("Filtering by : ${filterController.text}");
                                AutoRouter.of(context).push(
                                  SellingRoute(ongoing: !widget.ongoing), //Only 2 states, so if changed it will be the opposite of ongoing
                                );
                              }
                            }
                          },
                          items: <String>[
                            'Ongoing',
                            'Ended',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(value, style: myTextStyles.fadedText)),
                            );
                          }).toList(),
                          isDense: true,
                          iconSize: 0.0, // Set the icon size to 0
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: Text("My Listings",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Expanded(
            child: FutureBuilder(
                future: listingFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<ListingModel> data =
                          snapshot.data as List<ListingModel>;
                      if (data != outputList) {
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
