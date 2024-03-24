import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/listing_controller.dart';
import '../models/listing_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

@RoutePage()
class CreateListingPage extends StatefulWidget {
  const CreateListingPage({super.key});

  @override
  State<CreateListingPage> createState() => _CreateListingPageState();
}

//widget.documentID
class _CreateListingPageState extends State<CreateListingPage> {
  double distanceToField = 0;
  final listingNameController = TextEditingController();
  final listingEndController = TextEditingController();

  final listingPriceController = TextEditingController();
  TextfieldTagsController listingTagsController = TextfieldTagsController();
  String? imageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    listingTagsController.dispose();
  }

  @override
  void initState() {
    super.initState();
    listingTagsController = TextfieldTagsController();
  }

  @override
  Widget build(BuildContext context) {
    listingEndController.text = '1 day';
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
              DropdownButtonFormField<String>(
                value: listingEndController.text, // Set the initial value
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    listingEndController.text = newValue; // Update the controller value
                  }
                },
                items: <String>['1 day', '3 days', '7 days']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
                SizedBox(height: 10),
                //TODO - Turn into some sort of text field that can add items to list. Max at 4 tags? Char limit of 8?
                Text(
                  "Tags",
                  style: myTextStyles.defaultText,
                ),
                TextFieldTags(
                  textfieldTagsController: listingTagsController,
                  inputfieldBuilder: (context,
                      TextEditingController tec,
                      FocusNode fn,
                      String? error,
                      void Function(String)? onChanged,
                      void Function(String)? onSubmitted) {
                    return ((context, sc, tags, onTagDelete) {
                      print("test");
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: tec,
                          focusNode: fn,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 74, 137, 92),
                                width: 3.0,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 74, 137, 92),
                                width: 3.0,
                              ),
                            ),
                            hintText: listingTagsController.hasTags ? '' : "Enter tags...",
                            errorText: error,
                            prefixIconConstraints: BoxConstraints(
                                maxWidth: distanceToField * 0.74),
                            prefixIcon: tags.isNotEmpty
                                ? SingleChildScrollView(
                                    controller: sc,
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        children: tags.map((String tag) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              child: Text(
                                                '#$tag',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onTap: () {
                                                print("$tag selected");
                                              },
                                            ),
                                            const SizedBox(width: 4.0),
                                            InkWell(
                                              child: const Icon(
                                                Icons.cancel,
                                                size: 14.0,
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                              ),
                                              onTap: () {
                                                onTagDelete(tag);
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                  )
                                : null,
                          ),
                          onChanged: onChanged,
                          onSubmitted: onSubmitted,
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: 10),
                Text(
                  "Ticket price",
                  style: myTextStyles.defaultText,
                ),
                TextFormField(
                  controller: listingPriceController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number
                ),
                SizedBox(height: 10),
                IconButton(onPressed: () async {

                  ImagePicker imagePicker=ImagePicker();
                  //TODO allow user to select gallery OR camera
                  XFile? file = await imagePicker.pickImage(source: ImageSource.camera);

                  if(file == null) return; //exit function if no image
                  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

                  imageUrl = await Get.put(ListingController()).uploadImage(file, uniqueFileName);
                  //TODO refresh the page with the image we just uploaded

                }, icon: Icon(Icons.camera_alt)),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: standardButton,
                  onPressed: () {

                    int timeIncrement = int.parse(listingEndController.text[0]);
                    DateTime newTime = new DateTime.now().add(Duration(days: timeIncrement));

                    print('Modifying time by: ');
                    print('New date is $newTime');
                  },
                  icon: Icon(Icons.add, size: 32),
                  label: const Text('Date Time'),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  style: standardButton,
                  onPressed: () async{

                    //exit function if no image TODO update function for all fields
                    if(imageUrl == null){
                      //TODO implement snackbar error instead of print
                      print("Upload Image (URL Null)");
                      return;
                    }
                    int timeIncrement = int.parse(listingEndController.text[0]);
                    //todo changed days in future to minutes to make testing easier, will go back on this later
                    DateTime newTime = new DateTime.now().add(Duration(minutes: timeIncrement));
                    int timestampInSeconds = newTime.millisecondsSinceEpoch;

                    final listing = ListingModel(
                      name: listingNameController.text,
                      hostID: FirebaseAuth.instance.currentUser!.uid,
                      endDate: timestampInSeconds, //todo TEMP
                      tags: listingTagsController.getTags,
                      primaryImage: imageUrl!,
                      ticketPrice: int.parse(listingPriceController.text)
                    );
                    print("Creating Listing");
                    Get.put(ListingController()).createListing(listing);
                    AutoRouter.of(context).pop();
                  },
                  icon: Icon(Icons.add, size: 32),
                  label: const Text('Create Listing'),
                ),
              ],
            ),
          ),
        ),
      ),
        resizeToAvoidBottomInset: false
    );
  }
}
