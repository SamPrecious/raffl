import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
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
              if (snapshot.connectionState == ConnectionState.done) {
                ListingModel listing = snapshot.data as ListingModel;
                int endTime = listing.getDate();
                print(listing.toString());
                //UserDataModel userData = snapshot.data as UserDataModel;
                if (snapshot.hasData) {
                  return (Column(
                    children: [
                      TitleHeaderWidget(title: 'Listing Details'),
                      AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            listing.getPrimaryImageURL(),
                            fit: BoxFit.cover,
                          )),
                      SizedBox(height: 10),
                      Text('Ticket Price: ' +
                          listing.getTicketPrice().toString()),
                      //TODO make this main page 'view_listing_page' BUT have subpages/routes for different implementation based on who owns
                      if (listing.getHostID().toString() ==
                          FirebaseAuth.instance.currentUser!.uid)
                        Text('I OWN THIS')
                      else
                        Text('I DO NOT OWN THIS'),
                      ElevatedButton.icon(
                        style: standardButton,
                        onPressed: () async {
                          print('Buying new ticket: ');
                          await controller.updateTickets(
                              listing.getDocumentID(), 1);
                        },
                        icon: Icon(Icons.airplane_ticket, size: 32),
                        label: const Text('Buy Ticket'),
                      ),
                      SizedBox(height: 20),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        child: CustomCountdownTimer(
                          endTime: endTime,
                        ),
                      ),
                      //Text('ends in '+ endDate),
                    ],
                  ));
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
