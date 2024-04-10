//The home screen for Raffl
import 'package:algolia/algolia.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/controllers/inbox_controller.dart';
import 'package:raffl/controllers/listing_controller.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/listing_model.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/listing_result_widget.dart';
import '../controllers/algolia_listings_controller.dart';
import 'package:get/get.dart';


@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Future<List<List<ListingModel>>>? homepageFutures;
  ListingController recentlyViewedController = Get.put(ListingController());
  UserDataController userDataController = Get.put(UserDataController());
  void initState() {
    super.initState();
    homepageFutures = recentlyViewedController.getHomepageResults();
    //recentlyViewedFuture = ;

    //recentlyViewedFuture = homepageFutures[0];
    //recommendedFuture = userDataController.getRecommendations
  }

  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser!; //Gets user information

    return Scaffold(
      resizeToAvoidBottomInset: false, //Stops trying to resize when keyboard appears
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded, size: 30),
                      onPressed: () {
                        print("back");
                        AutoRouter.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Transform.scale(
                        scale: 0.9,
                        child: SearchBar(
                          onSubmitted: (query){
                            AutoRouter.of(context).push(SearchResultsRoute(searchInput: query, soldItems: false));
                          },
                          leading: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 15,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          AutoRouter.of(context).push(ProfileRoute());
                        },
                        icon: Icon(Icons.person_rounded, size: 32),
                        style: circularButton,

                      ),
                    ), // Empty container for the remaining space
                  ),
                ],
              ),
            ),
            Center(
              child: Text("Recently Viewed",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: homepageFutures,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<List<ListingModel>> data = snapshot.data as List<List<ListingModel>>;
                        List<ListingModel> recommendedData = data[0];
                        int outputLength = recommendedData.length;

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
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      horizontal: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
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
                                        ListingModel item = recommendedData[index];
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
            Center(
              child: Text("Recommended",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: homepageFutures,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        List<List<ListingModel>> data = snapshot.data as List<List<ListingModel>>;
                        List<ListingModel> recommendedData = data[1];
                        int outputLength = recommendedData.length;

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
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                      horizontal: BorderSide(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
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
                                        ListingModel item = recommendedData[index];
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
          ],
        ),
      ),
    );
  }

}


