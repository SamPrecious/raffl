import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';
import '../controllers/listing_controller.dart';
import 'package:get/get.dart';
import 'package:raffl/styles/text_styles.dart';

import '../models/listing_model.dart';

@RoutePage()
class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

//widget.documentID
class _CreateListingPageState extends State<CreateListingPage> {

  final listingNameController = TextEditingController();
  final listingEndController = TextEditingController();
  final listingTagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width *
                0.7, //Makes sure safe area only takes up 70% of screen
            child: Column(
              children: [
                SizedBox(height: 80),
                Text(
                  "Create Listing",
                  style: myTextStyles.titleText,
                ),
                SizedBox(height: 40),
                Text(
                  "Name",
                  style: myTextStyles.defaultText,
                ),
                TextFormField(
                  controller: listingNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                //TODO - Turn into dropdown with 1, 3 and 7 days
                Text(
                  "End Date",
                  style: myTextStyles.defaultText,
                ),
                TextFormField(
                  controller: listingEndController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                //TODO - Turn into some sort of text field that can add items to list. Max at 4 tags? Char limit of 8?
                Text(
                  "Tags",
                  style: myTextStyles.defaultText,
                ),
                TextFormField(
                  controller: listingTagsController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: standardButton,
                  onPressed: () {
                    print(listingNameController.text.toString());
                    final listing = ListingModel(
                      name: listingNameController.text,
                      endDate: 100, //todo TEMP
                      //todo TAGS
                    );
                    Get.put(ListingController()).createListing(listing);
                    print("Created Listing");
                  },
                  icon: Icon(Icons.add, size: 32),
                  label: const Text('Create Listing'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
