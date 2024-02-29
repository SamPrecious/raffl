import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:raffl/controllers/notification_controller.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/custom_countdown_timer_widget.dart';
import 'package:raffl/widgets/title_header_widget.dart';
import '../controllers/listing_controller.dart';
import 'package:get/get.dart';

import '../models/listing_model.dart';
import '../styles/standard_button.dart';

@RoutePage()
class ViewListingPage extends StatefulWidget {
  final String documentID;

  const ViewListingPage({super.key, required this.documentID});

  @override
  State<ViewListingPage> createState() => _ViewListingPageState();
}

//widget.documentID
class _ViewListingPageState extends State<ViewListingPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListingController());

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: controller.getListing(widget.documentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done)  {
                ListingModel listing = snapshot.data as ListingModel;
                int endTime = listing.getDate();
                print(listing.toString());
                double itemSpacing = 6.0;
                final ValueNotifier<int> ticketsOwned = ValueNotifier<int>(listing.getTicketsOwned());
              //UserDataModel userData = snapshot.data as UserDataModel;
                if (snapshot.hasData) {
                  return DefaultTextStyle(
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    child: (Column(
                      children: [
                        //Change the title of the page based on if we own it or not
                        if (listing.getHostID().toString() == FirebaseAuth.instance.currentUser!.uid) ...[
                          TitleHeaderWidget(title: 'My Listing'),
                        ] else ...[
                          TitleHeaderWidget(title: 'Listing Details'),
                        ],
                        AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.network(
                              listing.getPrimaryImageURL(),
                              fit: BoxFit.cover,
                            )),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              //padding: EdgeInsets.only(top: 200, bottom: 200),
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(listing.getName(),
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Ticket Price:'),
                                    Text('£' +
                                        listing.getTicketPrice().toString()),
                                  ],
                                ),
                                SizedBox(height: itemSpacing),
                                if (listing.getHostID().toString() != FirebaseAuth.instance.currentUser!.uid) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Tickets Owned:'),
                                      ValueListenableBuilder
                                        (valueListenable: ticketsOwned,
                                          builder: (context, value, child){
                                            return Text(value.toString());
                                          },
                                      ),
                                      //Text(ticketsOwned.toString()),
                                      //controller.getTickets(listing.getDocumentID())
                                    ],
                                  ),
                                  SizedBox(height: itemSpacing),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Wrapped buttons in containers to make height uniform
                                      Container(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          style: standardButton,
                                          onPressed: () {
                                            // Your code here
                                          },
                                          icon: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 0),
                                            // adjust the padding as needed
                                            child: Icon(Icons.watch_later),
                                          ),
                                          label: const Text('Watch'),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: standardButton,
                                          onPressed: () async {
                                            await controller.updateTickets(
                                                listing.getDocumentID(), 1);
                                            ticketsOwned.value += 1;
                                            /*
                                              By storing the notification name as a timestamp, we:
                                                  Save storage on extra value
                                                  Make sorting easier
                                                  Have a unique ID
                                             */
                                            String notifTimestampName = DateTime.now().millisecondsSinceEpoch.toString();
                                            //TODO add notification/inbox value upon buying tickets
                                            NotificationModel tmpNotif = NotificationModel(
                                              id: notifTimestampName,
                                              listingID: listing.getDocumentID(),
                                              notificationName: listing.getName(),
                                              imageUrl: listing.getPrimaryImageURL(),
                                              description: 'Bought [IMPLEMENT] tickets',
                                            );
                                            NotificationController().createNotification(tmpNotif);

                                          },
                                          child: const Text('Buy Tickets'),
                                        ),
                                      ),

                                    ],
                                  ),
                                ], // Add your condition here
                                  //Only display this if we are NOT the owner, as owner can't buy ticket for their own item

                                SizedBox(height: itemSpacing),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Ending in:"),
                                    CustomCountdownTimer(
                                      endTime: endTime,
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tickets Sold:'),
                                    Text('TODO'),
                                  ],
                                ),
                                SizedBox(height: itemSpacing),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Watching:'),
                                    Text('TODO'),
                                  ],
                                ),
                                SizedBox(height: itemSpacing),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Interested:'),
                                    Text('TODO'),
                                  ],
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1.0,
                                ),
                                Text(
                                    "Description here: tmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmptmp")
                              ],
                            ),
                          ),
                        ),

                        //TODO make this main page 'view_listing_page' BUT have subpages/routes for different implementation based on who owns
                      ],
                    )),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: Text("Error, no data found"));
                }
              }
              //Returns loading bar until data is retrieved
              else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
