import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/listing_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/listing_result_widget.dart';

@RoutePage()
class WatchingPage extends StatefulWidget {

  WatchingPage(
      {super.key});

  @override
  State<WatchingPage> createState() => _WatchingPageState();
}

class _WatchingPageState extends State<WatchingPage> {
  final searchController = TextEditingController();
  List<ListingModel> outputList = [];
  List<ListingModel> filteredList = [];

  Future? listingFuture;
  ListingController listingController = Get.put(ListingController());


  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
    listingFuture = listingController.getWatching();
  }

  //Filter the list
  onSearchChanged(){
    print("Search input: ${searchController.text}");
    setState(() {
      print("Output list is: ${filteredList}");
      filteredList = outputList.where((item) {
        print("Search results: ${item.getName().toLowerCase().contains(searchController.text.toLowerCase())}");
        return item.getName().toLowerCase().contains(searchController.text.toLowerCase());
      }).toList();
    });

  }

  @override
  Widget build(BuildContext context) {

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
                    child: Transform.scale(
                      scale: 0.9,
                      child: SearchBar(
                        controller: searchController,
                        onSubmitted: (query) {
                          //TODO Implement
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
          Center(
            child: Text("Watching",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: listingFuture,
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
          ),
        ]),
      ),
      resizeToAvoidBottomInset:
      false, //Avoids whitespace above keyboard blocking content
    );
  }
}