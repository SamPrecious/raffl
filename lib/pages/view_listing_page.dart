import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:raffl/controllers/inbox_controller.dart';
import 'package:raffl/controllers/push_notification_controller.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/address_model.dart';
import 'package:raffl/models/notification_model.dart';
import 'package:raffl/models/shipping_details_model.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/address_widget.dart';
import 'package:raffl/widgets/custom_countdown_timer_widget.dart';
import 'package:raffl/widgets/label_value_listenable_pair_widget.dart';
import 'package:raffl/widgets/label_value_pair_widget.dart';
import 'package:raffl/widgets/mandatory_input_widget.dart';
import 'package:raffl/widgets/optional_input_widget.dart';
import 'package:raffl/widgets/title_header_widget.dart';
import '../controllers/listing_controller.dart';
import 'package:get/get.dart';
import '../models/listing_model.dart';
import '../styles/standard_button.dart';
import 'package:raffl/styles/text_styles.dart';

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
  final pushNotificationController = Get.put(PushNotificationController());
  ValueNotifier<bool> userIsWatching = ValueNotifier<bool>(false);
  bool userIsHost = false;
  int userCredits = 0;

  //Refreshes page when listing ends
  void listingHasEnded(hasEnded) async{
    print("Listing has JUST ended");
    final currentRouteName = AutoRouter.of(context).topRoute.name;

    if(currentRouteName == ViewListingRoute.name){ //Refresh page if we are still on it
      AutoRouter.of(context)
          .popAndPush(ViewListingRoute(documentID: widget.documentID));
    }
  }



  @override
  void dispose() {
    userIsWatching.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    listingController.getListing(widget.documentID).then((listing) async {
      userIsHost = (listing.getHostID().toString() ==
          FirebaseAuth.instance.currentUser!.uid);
      userCredits = await userDataController.getUserCredits();
      String listingDocumentID = listing.getDocumentID();
      if (!userIsHost) {
        //await controller.updateTickets(listing.getDocumentID(), 1);
        await listingController.incrementViews(listingDocumentID);
        bool isUserWatching =
        await userDataController.isUserWatching(listingDocumentID);
        setState(() {
          userIsWatching.value = isUserWatching;
        });
        //TODO Add item to recently viewed
        await userDataController.updateRecentlyViewed(listingDocumentID);

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
                  AddressModel? address;
                  bool hasAddress = listing.hasAddress();
                  if (hasAddress) {
                    address = listing.getAddress();
                  }
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
                      //Item is sold, so retrieve address if it exists
                      if (winnerId == uid) {
                        isWinner = true;
                      }
                    }
                  }
                  print("Pagetype is: ${pageType}");
                  print("Winner status: ${isWinner}");
                  double itemSpacing = 6.0;
                  final ValueNotifier<int> ticketsOwned =
                      ValueNotifier<int>(listing.getTicketsOwned());
                  final ValueNotifier<int> ticketsSold =
                      ValueNotifier<int>(listing.getTicketsSold());
                  final ValueNotifier<int> usersInterested =
                      ValueNotifier<int>(listing.getUsersInterested());
                  final ValueNotifier<int> usersWatching =
                      ValueNotifier<int>(listing.getUsersWatching());
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

                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              //padding: EdgeInsets.only(top: 200, bottom: 200),
                              children: [
                                AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: Image.network(
                                      listing.getPrimaryImageURL(),
                                      fit: BoxFit.cover,
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Column(
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
                                              listing
                                                  .getTicketPrice()
                                                  .toString(),
                                          itemSpacing: itemSpacing),

                                      SizedBox(height: itemSpacing),
                                      if (!userIsHost) ...[
                                        LabelValueListenablePairWidget(
                                            label: 'Tickets Owned:',
                                            value: ticketsOwned,
                                            itemSpacing: itemSpacing),
                                        Row(
                                          mainAxisAlignment: pageType ==
                                                  PageType.unfinished
                                              ? MainAxisAlignment.spaceBetween
                                              : MainAxisAlignment.center,
                                          children: [
                                            //Wrapped buttons in containers to make height uniform
                                            Container(
                                              width: 150,
                                              height: 50,
                                              child: ValueListenableBuilder(
                                                  //Use this so we can modify the button when user watches/unwatches
                                                  valueListenable:
                                                      userIsWatching,
                                                  builder:
                                                      (context, value, child) {
                                                    return ElevatedButton.icon(
                                                      style: standardButton,
                                                      onPressed: () async {
                                                        //We get watching status directly from database, rather than local page value, in-case it has changed (i.e. user clicked watch on another device)
                                                        userIsWatching.value =
                                                            await userDataController
                                                                .addOrRemoveWatch(
                                                                    listing
                                                                        .getDocumentID());
                                                        if (userIsWatching
                                                            .value) {
                                                          usersWatching.value +=
                                                              1;
                                                        } else {
                                                          usersWatching.value -=
                                                              1;
                                                        }
                                                        await listingController
                                                            .modifyWatchers(
                                                                listing
                                                                    .getDocumentID(),
                                                                userIsWatching
                                                                    .value);
                                                      },
                                                      icon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 0),
                                                        // adjust the padding as needed
                                                        child: value
                                                            ? Image.asset(
                                                                'assets/icons/watch_black.png')
                                                            : Image.asset(
                                                                'assets/icons/watch_white.png'),
                                                      ),
                                                      label:
                                                          const Text('Watch'),
                                                    );
                                                  }),
                                            ),
                                            if (pageType ==
                                                PageType.unfinished) ...[
                                              //Only let us buy tickets if listing is unfinished
                                              Container(
                                                width: 150,
                                                height: 50,
                                                child: ElevatedButton(
                                                  style: standardButton,
                                                  onPressed: () async {
                                                    TextEditingController
                                                        ticketNum =
                                                        TextEditingController();
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          dialogContext) {
                                                        final inputKey =
                                                            GlobalKey<
                                                                FormState>();
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Buy Tickets',
                                                              style: TextStyle(
                                                                color:
                                                                    secondaryColor,
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                          content: Form(
                                                            key: inputKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      ticketNum,
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText:
                                                                              'Enter number of tickets'),
                                                                  keyboardType:
                                                                      TextInputType.numberWithOptions(
                                                                          decimal:
                                                                              false),
                                                                  validator:
                                                                      (value) {
                                                                    int?
                                                                        number =
                                                                        int.tryParse(
                                                                            value!);
                                                                    if (number ==
                                                                            null ||
                                                                        number <=
                                                                            0) {
                                                                      return 'Please enter a valid number of tickets';
                                                                    } else {
                                                                      int totalCost =
                                                                          listing.getTicketPrice() *
                                                                              number;
                                                                      if (userCredits <
                                                                          totalCost) {
                                                                        return 'You do not have enough credits';
                                                                      }
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          actions: [
                                                            Center(
                                                              child:
                                                                  ElevatedButton(
                                                                child:
                                                                    Text('Buy'),
                                                                style:
                                                                    standardButton,
                                                                onPressed:
                                                                    () async {
                                                                  if (inputKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    int number =
                                                                        int.parse(
                                                                            ticketNum.text);
                                                                    try {
                                                                      bool ticketsBought = await listingController.buyTickets(
                                                                          listing
                                                                              .getDocumentID(),
                                                                          number,
                                                                          listing
                                                                              .getTicketPrice());
                                                                      if (!ticketsBought) {
                                                                        print(
                                                                            "Tickets were not brought, exiting function");
                                                                        return;
                                                                      }
                                                                    } catch (e) {
                                                                      print(
                                                                          'Failed to update tickets: $e');
                                                                    }
                                                                    if (ticketsOwned
                                                                            .value ==
                                                                        0) {
                                                                      //If this is our users first ticket, then UsersInterested is updated by 1. Reflect this in page
                                                                      usersInterested
                                                                          .value += 1;
                                                                      print(
                                                                          "Incrementing users interested");
                                                                    }
                                                                    ticketsOwned
                                                                            .value +=
                                                                        number;
                                                                    ticketsSold
                                                                            .value +=
                                                                        number;
                                                                    /*
                                                                                                      By storing the notification name as a timestamp, we:
                                                                                                          Save storage on extra value
                                                                                                          Make sorting easier
                                                                                                          Have a unique ID
                                                                                                     */
                                                                    String
                                                                        notifTimestampName =
                                                                        DateTime.now()
                                                                            .millisecondsSinceEpoch
                                                                            .toString();
                                                                    NotificationModel
                                                                        boughtNotification =
                                                                        NotificationModel(
                                                                      id: notifTimestampName,
                                                                      listingID:
                                                                          listing
                                                                              .getDocumentID(),
                                                                      notificationName:
                                                                          listing
                                                                              .getName(),
                                                                      imageUrl:
                                                                          listing
                                                                              .getPrimaryImageURL(),
                                                                      description:
                                                                          'Bought ${number} tickets',
                                                                    );
                                                                    InboxController()
                                                                        .createInboxEntry(
                                                                            boughtNotification);
                                                                    Navigator.of(
                                                                            dialogContext)
                                                                        .pop();
                                                                    userCredits =
                                                                        await userDataController
                                                                            .getUserCredits();
                                                                  } else {
                                                                    print(
                                                                        "ERROR");
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child:
                                                      const Text('Buy Tickets'),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                      //Only display this if we are NOT the owner, as owner can't buy ticket for their own item
                                      SizedBox(height: itemSpacing),
                                      Row(
                                        mainAxisAlignment:
                                            pageType == PageType.unfinished
                                                ? MainAxisAlignment.spaceBetween
                                                : MainAxisAlignment.center,
                                        children: [
                                          if (pageType ==
                                              PageType.unfinished) ...[
                                            Text("Ending in:"),
                                            CustomCountdownTimer(
                                              endTime: endTime,
                                              timesUp: listingHasEnded,
                                            ),
                                          ] else if (pageType ==
                                              PageType.sold) ...[
                                            if (isWinner) ...[
                                              Column(
                                                children: [
                                                  Text(
                                                    "Congratulations, you won!",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  if (!hasAddress) ...[
                                                    ElevatedButton(
                                                      style: standardButton,
                                                      onPressed: () async {
                                                        TextEditingController
                                                            nameController =
                                                            TextEditingController();
                                                        TextEditingController
                                                            addressController =
                                                            TextEditingController();
                                                        TextEditingController
                                                            postcodeController =
                                                            TextEditingController();
                                                        TextEditingController
                                                            cityController =
                                                            TextEditingController();
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              dialogContext) {
                                                            final inputKey =
                                                                GlobalKey<
                                                                    FormState>();
                                                            return AlertDialog(
                                                              title: Text(
                                                                  'Enter shipping details'),
                                                              content:
                                                                  SingleChildScrollView(
                                                                //Allow scrolling if screen size is too small (unlikely but possible)
                                                                child: Form(
                                                                  key: inputKey,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      MandatoryInputWidget(
                                                                        label:
                                                                            "Name",
                                                                        textEditingController:
                                                                            nameController,
                                                                      ),
                                                                      MandatoryInputWidget(
                                                                        label:
                                                                            "Address",
                                                                        textEditingController:
                                                                            addressController,
                                                                        maxLines:
                                                                            3,
                                                                      ),
                                                                      MandatoryInputWidget(
                                                                        label:
                                                                            "Postcode",
                                                                        textEditingController:
                                                                            postcodeController,
                                                                      ),
                                                                      MandatoryInputWidget(
                                                                        label:
                                                                            "Town/City",
                                                                        textEditingController:
                                                                            cityController,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: [
                                                                Center(
                                                                  child:
                                                                      ElevatedButton(
                                                                    child: const Text(
                                                                        'Submit'),
                                                                    style:
                                                                        standardButton,
                                                                    onPressed:
                                                                        () async {
                                                                      if (inputKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        // If the form is valid, display a Snackbar.
                                                                        final address =
                                                                            AddressModel(
                                                                          name:
                                                                              nameController.text,
                                                                          address:
                                                                              addressController.text,
                                                                          postcode:
                                                                              postcodeController.text,
                                                                          city:
                                                                              cityController.text,
                                                                        );
                                                                        Get.put(ListingController()).addAddress(
                                                                            listing.getDocumentID(),
                                                                            address);

                                                                        String notifTimestampName = DateTime.now()
                                                                            .millisecondsSinceEpoch
                                                                            .toString();
                                                                        NotificationModel
                                                                            addressReceivedNotification =
                                                                            NotificationModel(
                                                                          id: notifTimestampName,
                                                                          listingID:
                                                                              listing.getDocumentID(),
                                                                          notificationName:
                                                                              listing.getName(),
                                                                          imageUrl:
                                                                              listing.getPrimaryImageURL(),
                                                                          description:
                                                                              'Winner address received, please ship now',
                                                                        );
                                                                        String
                                                                            hostID =
                                                                            listing.getHostID();

                                                                        await pushNotificationController.sendPushNotification(
                                                                            hostID,
                                                                            addressReceivedNotification);

                                                                        Navigator.of(dialogContext)
                                                                            .pop();
                                                                        AutoRouter.of(context).popAndPush(ViewListingRoute(
                                                                            documentID:
                                                                                listing.getDocumentID()));

                                                                        //TODO refresh page AND send notification
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      child: const Text(
                                                          "Add Address"),
                                                    ),
                                                  ] else ...[
                                                    if (listing
                                                        .hasShippingDetails()) ...[
                                                      if (listing
                                                          .hasBeenReceived()) ...[
                                                        Text("Enjoy your item")
                                                      ] else ...[
                                                        Text(
                                                            "Item has been shipped"),
                                                        ElevatedButton(
                                                          style: standardButton,
                                                          onPressed: () async {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                                  dialogContext) {
                                                                return AlertDialog(
                                                                  title: Center(
                                                                    child: Text(
                                                                      'Mark as Received?',
                                                                      style:
                                                                          TextStyle(
                                                                        color:
                                                                            secondaryColor,
                                                                        fontSize:
                                                                            24,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    Center(
                                                                      child:
                                                                          ElevatedButton(
                                                                        child: const Text(
                                                                            'Confirm'),
                                                                        style:
                                                                            standardButton,
                                                                        onPressed:
                                                                            () async {
                                                                          Get.put(ListingController())
                                                                              .markReceived(listing.getDocumentID());
                                                                          Navigator.of(dialogContext)
                                                                              .pop();
                                                                          String
                                                                              hostID =
                                                                              listing.getHostID();
                                                                          Get.put(UserDataController()).awardCredits(
                                                                              hostID,
                                                                              ticketsSold.value * listing.getTicketPrice());

                                                                          String
                                                                              notifTimestampName =
                                                                              DateTime.now().millisecondsSinceEpoch.toString();
                                                                          NotificationModel
                                                                              boughtNotification =
                                                                              NotificationModel(
                                                                            id: notifTimestampName,
                                                                            listingID:
                                                                                listing.getDocumentID(),
                                                                            notificationName:
                                                                                listing.getName(),
                                                                            imageUrl:
                                                                                listing.getPrimaryImageURL(),
                                                                            description:
                                                                                'Item received. You have been awarded £${ticketsSold.value * listing.getTicketPrice()} credits',
                                                                          );
                                                                          //NotificationController().createNotification(boughtNotification, hostID);
                                                                          //Sends push notification to host AND generates inbox item
                                                                          await pushNotificationController.sendPushNotification(
                                                                              hostID,
                                                                              boughtNotification);

                                                                          AutoRouter.of(context)
                                                                              .popAndPush(ViewListingRoute(documentID: listing.getDocumentID()));
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          },
                                                          child: const Text(
                                                              'Mark as Received'),
                                                        ),
                                                      ],
                                                    ] else ...[
                                                      Text(
                                                          "Waiting for seller to ship item:"),
                                                    ],
                                                    AddressWidget(
                                                      address: address!,
                                                      itemSpacing: itemSpacing,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ] else if (userIsHost) ...[
                                              Column(
                                                children: [
                                                  Text("Your item has sold"),
                                                  if (hasAddress) ...[
                                                    if (!listing
                                                        .hasShippingDetails()) ...[
                                                      Text("Send Item To:"),
                                                      AddressWidget(
                                                        address: address!,
                                                        itemSpacing:
                                                            itemSpacing,
                                                      ),
                                                      SizedBox(height: 10),
                                                      ElevatedButton(
                                                        style: standardButton,
                                                        onPressed: () async {
                                                          TextEditingController
                                                              courierController =
                                                              TextEditingController();
                                                          TextEditingController
                                                              trackerController =
                                                              TextEditingController();
                                                          showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                dialogContext) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Mark as Shipped?',
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          secondaryColor,
                                                                      fontSize:
                                                                          24,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                                content:
                                                                    SingleChildScrollView(
                                                                  //Allow scrolling if screen size is too small (unlikely but possible)
                                                                  child: Form(
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        OptionalInputWidget(
                                                                          label:
                                                                              "Courier",
                                                                          textEditingController:
                                                                              courierController,
                                                                        ),
                                                                        OptionalInputWidget(
                                                                          label:
                                                                              "Tracking Number",
                                                                          textEditingController:
                                                                              trackerController,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  Center(
                                                                    child:
                                                                        ElevatedButton(
                                                                      child: const Text(
                                                                          'Confirm'),
                                                                      style:
                                                                          standardButton,
                                                                      onPressed:
                                                                          () async {
                                                                        final shippingDetails =
                                                                            ShippingDetailsModel(
                                                                          courier:
                                                                              courierController.text ?? "",
                                                                          trackingNumber:
                                                                              trackerController.text ?? "",
                                                                        );
                                                                        Get.put(ListingController()).addShippingDetails(
                                                                            listing.getDocumentID(),
                                                                            shippingDetails);

                                                                        String notifTimestampName = DateTime.now()
                                                                            .millisecondsSinceEpoch
                                                                            .toString();
                                                                        NotificationModel
                                                                            addressReceivedNotification =
                                                                            NotificationModel(
                                                                          id: notifTimestampName,
                                                                          listingID:
                                                                              listing.getDocumentID(),
                                                                          notificationName:
                                                                              listing.getName(),
                                                                          imageUrl:
                                                                              listing.getPrimaryImageURL(),
                                                                          description:
                                                                              'Your item has been shipped and should be with you shortly',
                                                                        );
                                                                        String
                                                                            winnerID =
                                                                            listing.getWinnerID();

                                                                        await pushNotificationController.sendPushNotification(
                                                                            winnerID,
                                                                            addressReceivedNotification);

                                                                        Navigator.of(dialogContext)
                                                                            .pop();

                                                                        AutoRouter.of(context).popAndPush(ViewListingRoute(
                                                                            documentID:
                                                                                listing.getDocumentID()));
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: const Text(
                                                            'Mark as Shipped'),
                                                      ),
                                                    ] else ...[
                                                      Text(
                                                          "Item has been shipped"),
                                                      if (listing
                                                          .hasBeenReceived()) ...[
                                                        Text(
                                                            "User has confirmed"),
                                                        Text(
                                                            "You have received £${ticketsSold.value * listing.getTicketPrice()}")
                                                      ] else ...[
                                                        Text(
                                                            "Waiting for user confirmation"),
                                                      ],
                                                    ],
                                                  ] else ...[
                                                    Text(
                                                        "Awaiting user address"),
                                                  ],
                                                ],
                                              ),
                                            ] else if (!isWinner &&
                                                !userIsHost) ...[
                                              Text(
                                                "Sorry, you didn't win.\nBetter luck next time!",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ] else if (pageType == PageType.unsold) ...[
                                            Text(
                                              "Listing ended without tickets sold.",
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
                              ],
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
