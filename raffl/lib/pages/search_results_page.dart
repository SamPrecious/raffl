import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/algolia_listings_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import 'package:raffl/styles/text_styles.dart';

@RoutePage()
class SearchResultsPage extends StatefulWidget {
  final String searchInput;
  final String? sortInput;
  final bool soldItems;
  final RangeValues? priceRange;

  SearchResultsPage(
      {super.key,
      required this.searchInput,
      this.sortInput,
      required this.soldItems,
      this.priceRange});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final searchInputController = TextEditingController();
  final filterController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ValueNotifier<String> searchInputNotifier = ValueNotifier<String>(widget.searchInput);
    filterController.text = widget.sortInput ?? 'Sort (Default)';
    searchInputController.text = searchInputNotifier.value;
    RangeValues currentPriceRange = widget.priceRange ?? RangeValues(0, 50);

    bool soldItemCheckbox = widget.soldItems;
    AlgoliaListingsController algoliaListingsController =
        Get.put(AlgoliaListingsController());

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
            child: Column(
              children: [
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
                          child: Transform.scale(
                            scale: 0.9,
                            child: SearchBar(
                              controller: searchInputController,
                              onChanged: (query){
                                searchInputNotifier.value = query;
                              },
                              onSubmitted: (query) {
                                AutoRouter.of(context).push(
                                  SearchResultsRoute(
                                    searchInput: searchInputNotifier.value,
                                    sortInput: filterController.text,
                                    soldItems: soldItemCheckbox,
                                    priceRange: currentPriceRange,
                                  ),
                                );
                              },
                              leading: const Icon(Icons.search),
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
                Padding(
                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context,
                                      StateSetter setModalState) {
                                return Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: DefaultTextStyle(
                                      style: myTextStyles.defaultText,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          CheckboxListTile(
                                            title: Text("Finished Items"),
                                            activeColor: secondaryColor,
                                            checkColor: primaryColor,
                                            value: soldItemCheckbox,
                                            onChanged: (bool? value) {
                                              setModalState(() {
                                                soldItemCheckbox = value!;
                                              });
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 16.0, left: 16.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    'Price Range',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: RangeSlider(
                                                    values: currentPriceRange,
                                                    max: 50,
                                                    divisions: 50,
                                                    labels: RangeLabels(
                                                      "£ ${currentPriceRange.start.round().toString()}",
                                                      "£ ${currentPriceRange.end.round().toString()}",
                                                    ),
                                                    onChanged:
                                                        (RangeValues values) {
                                                      setModalState(() {
                                                        currentPriceRange =
                                                            values;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: const Text('Apply'),
                                            style: standardButton,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              AutoRouter.of(context).push(
                                                SearchResultsRoute(
                                                  searchInput: searchInputNotifier.value,
                                                  sortInput:
                                                      filterController.text,
                                                  soldItems: soldItemCheckbox,
                                                  priceRange: currentPriceRange,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        },
                        child: Text(
                          "Filter",
                          style: myTextStyles.fadedText,
                        ),
                      ),
                      DefaultTextStyle(
                        style: myTextStyles.fadedText,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ButtonTheme(
                            alignedDropdown: true,
                            //Matches dropdown width to button width
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: filterController.text,
                                // Set the initial value
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    //Use searchInput along with Sort value to push a new page
                                    print(
                                        "Currently on: ${filterController.text}");
                                    if (filterController.text != newValue) {
                                      filterController.text =
                                          newValue; // Update the controller value
                                      print(
                                          "Filtering by : ${filterController.text}");
                                      AutoRouter.of(context).push(
                                        SearchResultsRoute(
                                          searchInput: searchInputNotifier.value,
                                          sortInput: filterController.text,
                                          soldItems: soldItemCheckbox,
                                          priceRange: currentPriceRange,
                                        ),
                                      );
                                    }
                                  }
                                },
                                items: <String>[
                                  'Sort (Default)',
                                  'Ending Soonest',
                                  'Cheapest Tickets',
                                  'Most Sold',
                                  'Most Viewed'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(value,
                                            style: myTextStyles.fadedText)),
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
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: algoliaListingsController.getSearchResults(
                    searchInputNotifier.value,
                    filterController.text,
                    soldItemCheckbox,
                    currentPriceRange),
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
                            Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: searchInputNotifier.value.isEmpty
                                            ? "Everything:"
                                            : "Results for: ",
                                        style: myTextStyles.defaultTextBold,
                                      ),
                                      if (!searchInputNotifier.value.isEmpty)
                                        TextSpan(
                                          text: "${searchInputNotifier.value}",
                                          style: myTextStyles.defaultText,
                                        ),
                                    ],
                                  ),
                                )),
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
