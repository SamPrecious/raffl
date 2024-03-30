import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:raffl/controllers/notification_controller.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/custom_countdown_timer_widget.dart';
import 'package:raffl/widgets/label_value_listenable_pair_widget.dart';
import 'package:raffl/widgets/label_value_pair_widget.dart';
import 'package:raffl/widgets/title_header_widget.dart';
import '../controllers/listing_controller.dart';
import 'package:get/get.dart';
import '../models/listing_model.dart';
import '../styles/standard_button.dart';

enum PageType {
  sold,
  unsold,
  unfinished,
}

@RoutePage()
class ViewListingPage extends StatefulWidget {
  final String documentID;

  const ViewListingPage({super.key, required this.documentID});

  @override
  State<ViewListingPage> createState() => _ViewListingPageState();
}

//widget.documentID
class _ViewListingPageState extends State<ViewListingPage> {
  final listingController = Get.put(ListingController());
  final userDataController = Get.put(UserDataController());
  ValueNotifier<bool> userIsWatching = ValueNotifier<bool>(false);
  bool userIsHost = false;
  @override
  void initState() {
    super.initState();
    listingController.getListing(widget.documentID).then((listing) async {
      userIsHost = (listing.getHostID().toString() == FirebaseAuth.instance.currentUser!.uid);
      String listingDocumentID = listing.getDocumentID();
      if (!userIsHost) {
        //await controller.updateTickets(listing.getDocumentID(), 1);
        await listingController.incrementViews(listingDocumentID);

        setState(() async {
          userIsWatching.value = await userDataController.isUserWatching(listing.getDocumentID());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: listingController.getListing(widget.documentID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                ListingModel listing = snapshot.data as ListingModel;
                int endTime = listing.getDate();
                PageType pageType = PageType.unfinished;
                bool isWinner = false;
                if (endTime < DateTime.now().millisecondsSinceEpoch) {
                  //Listing is finished so is either sold or unsold
                  //If the listing has a winner associated, the item has sold
                  final winnerId = listing.getWinnerID();
                  if (winnerId == "invalid") {
                    pageType = PageType.unsold;
                  } else {
                    pageType = PageType.sold;
                    if (winnerId == uid) {
                      isWinner = true;
                    }
                  }
                }
                print("Pagetype is: ${pageType}");
                print("Winner status: ${isWinner}");
                double itemSpacing = 6.0;
                final ValueNotifier<int> ticketsOwned = ValueNotifier<int>(listing.getTicketsOwned());
                final ValueNotifier<int> ticketsSold = ValueNotifier<int>(listing.getTicketsSold());
                final ValueNotifier<int> usersInterested = ValueNotifier<int>(listing.getUsersInterested());
                final ValueNotifier<int> usersWatching = ValueNotifier<int>(listing.getUsersWatching());
                print("User is watching ${userIsWatching}");
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
                        if (userIsHost) ...[
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
                                LabelValuePairWidget(
                                    label: 'Ticket Price:',
                                    value: '£' +
                                        listing.getTicketPrice().toString(),
                                    itemSpacing: itemSpacing),

                                SizedBox(height: itemSpacing),
                                if (!userIsHost) ...[
                                  LabelValueListenablePairWidget(
                                      label: 'Tickets Owned:',
                                      value: ticketsOwned,
                                      itemSpacing: itemSpacing),
                                  Row(
                                    mainAxisAlignment:
                                        pageType == PageType.unfinished
                                            ? MainAxisAlignment.spaceBetween
                                            : MainAxisAlignment.center,
                                    children: [
                                      //Wrapped buttons in containers to make height uniform
                                      Container(
                                        width: 150,
                                        height: 50,
                                        child: ValueListenableBuilder( //Use this so we can modify the button when user watches/unwatches
                                          valueListenable: userIsWatching,
                                          builder: (context, value, child){
                                            return ElevatedButton.icon(
                                              style: standardButton,
                                              onPressed: () async{
                                                //We get watching status directly from database, rather than local page value, in-case it has changed (i.e. user clicked watch on another device)
                                                userIsWatching.value = await userDataController.addOrRemoveWatch(listing.getDocumentID());
                                                if(userIsWatching.value) {
                                                  usersWatching.value += 1;
                                                }else{
                                                  usersWatching.value -= 1;
                                                }
                                                await listingController.modifyWatchers(listing.getDocumentID(), userIsWatching.value);

                                              },
                                              icon: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 0),
                                                // adjust the padding as needed
                                                child: value ?
                                                Image.asset('assets/icons/watch_black.png'):
                                                Image.asset('assets/icons/watch_white.png'),
                                              ),
                                              label: const Text('Watch'),
                                            );
                                          }
                                        ),
                                      ),
                                      if (pageType == PageType.unfinished) ...[ //Only let us buy tickets if listing is unfinished
                                      Container(
                                        width: 150,
                                        height: 50,
                                        child: ElevatedButton(
                                          style: standardButton,
                                          onPressed: () async {
                                            TextEditingController ticketNum = TextEditingController();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext dialogContext) {
                                                final inputKey = GlobalKey<FormState>();
                                                return AlertDialog(
                                                  title: Text('Buy Tickets'),
                                                  content: Form(
                                                    key: inputKey,
                                                    child: TextFormField(
                                                      controller: ticketNum,
                                                      decoration: InputDecoration(hintText: 'Enter number of tickets'
                                                      ),
                                                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                                                      validator: (value) {
                                                        int? number = int.tryParse(value!);
                                                        if (number == null || number <= 0) {
                                                          return 'Please enter a valid number of tickets';
                                                        }else if(false){
                                                          //Check the user has enough money
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(dialogContext).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Buy'),
                                                      onPressed: () async {

                                                        if(inputKey.currentState!.validate()){
                                                          int number = int.parse(ticketNum.text);
                                                          try {
                                                            await listingController.buyTickets(listing.getDocumentID(), number);
                                                          } catch (e) {
                                                            print('Failed to update tickets: $e');
                                                          }
                                                          print("Tickets owned: {$ticketsOwned.value}");
                                                          if(ticketsOwned.value == 0){ //If this is our users first ticket, then UsersInterested is updated by 1. Reflect this in page
                                                            usersInterested.value += 1;
                                                            print("Incrementing users interested");
                                                          }
                                                          ticketsOwned.value += number;
                                                          ticketsSold.value += number;
                                                          /*
                                              By storing the notification name as a timestamp, we:
                                                  Save storage on extra value
                                                  Make sorting easier
                                                  Have a unique ID
                                             */
                                                          String notifTimestampName =
                                                          DateTime.now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                          NotificationModel tmpNotif =
                                                          NotificationModel(
                                                            id: notifTimestampName,
                                                            listingID:
                                                            listing.getDocumentID(),
                                                            notificationName:
                                                            listing.getName(),
                                                            imageUrl:
                                                            listing.getPrimaryImageURL(),
                                                            description:
                                                            'Bought ${number} tickets',
                                                          );
                                                          NotificationController()
                                                              .createNotification(tmpNotif);
                                                          Navigator.of(dialogContext).pop();
                                                        }else{
                                                          //TODO fix snackbar to appear above keyboard
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text('Please enter a valid number'))
                                                          );
                                                          print("ERROR");
                                                        }
                                                      },
                                                    ),
                                                  ],

                                                );
                                              },
                                            );

                                          },
                                          child: const Text('Buy Tickets'),
                                        ),
                                      ),
                                      ],
                                    ],
                                  ),
                                ],
                                // Add your condition here
                                //Only display this if we are NOT the owner, as owner can't buy ticket for their own item

                                SizedBox(height: itemSpacing),

                                Row(
                                  mainAxisAlignment:
                                  pageType == PageType.unfinished
                                      ? MainAxisAlignment.spaceBetween
                                      : MainAxisAlignment.center,
                                  children: [
                                    if (pageType == PageType.unfinished) ...[
                                      Text("Ending in:"),
                                      CustomCountdownTimer(
                                        endTime: endTime,
                                      ),
                                    ]else if(isWinner)...[
                                      Text(
                                        "Congratulations, you won!\nPlease enter your shipping details",
                                        textAlign: TextAlign.center,
                                      ),
                                    ]else if(!isWinner && !userIsHost)...[
                                      Text(
                                        "Sorry, you didn't win.\nBetter luck next time!",
                                        textAlign: TextAlign.center,
                                      ),
                                    ],

                                  ],
                                ),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1.0,
                                ),
                                LabelValueListenablePairWidget(
                                    label: 'Tickets Sold:',
                                    value: ticketsSold,
                                    itemSpacing: itemSpacing),
                                LabelValueListenablePairWidget(
                                    label: 'Watching:',
                                    value: usersWatching,
                                    itemSpacing: itemSpacing),
                                LabelValueListenablePairWidget(
                                    label: 'Users Interested:',
                                    value: usersInterested,
                                    itemSpacing: itemSpacing),
                                Divider(
                                  color: secondaryColor,
                                  thickness: 1.0,
                                ),
                                Text(listing.getDescription()),
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
        resizeToAvoidBottomInset: false);
  }
}
