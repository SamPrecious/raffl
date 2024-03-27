import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raffl/styles/colors.dart';
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
  final descriptionController = TextEditingController();
  TextfieldTagsController listingTagsController = TextfieldTagsController();
  String? imageUrl;
  bool isUploading =
      false; //When uploading image, this is temporarily set to true until it is fully uploaded

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
        body: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom - MediaQuery.of(context).padding.bottom), //This padding is the keyboard of the device, to jump when keyboard opens
          child: SafeArea(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.7, //Makes sure safe area only takes up 70% of screen
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Create Listing",
                        style: myTextStyles.titleText,
                      ),
                      SizedBox(height: 20),
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
                            listingEndController.text =
                                newValue; // Update the controller value
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
                                  hintText: listingTagsController.hasTags
                                      ? ''
                                      : "Enter tags...",
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
                                                color: Color.fromARGB(
                                                    255, 74, 137, 92),
                                              ),
                                              margin: const EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                      GestureDetector(
                        onTap: () async {
                          ImagePicker imagePicker = ImagePicker();
                          //TODO allow user to select gallery OR camera
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.camera);
          
                          if (file == null) return; //exit function if no image
                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          setState(() {
                            isUploading = true; //Image is in process of uploading
                          });
                          imageUrl = await Get.put(ListingController())
                              .uploadImage(file, uniqueFileName);
                          setState(() {
                            isUploading = false; //Image has uploaded
                          });
                          //TODO refresh the page with the image we just uploaded
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          child: isUploading
                              ? Center(child: CircularProgressIndicator())
                              : //If image is uploading, we have initial circular loading bar
                              imageUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        imageUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              //After image is uploaded, we have this circular progress indicator, with values to indicate how long it takes
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Icon(Icons.image, color: Colors.white), // Image picker icon,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      SizedBox(height: 10),
                      IconButton(
                          onPressed: () async {
                            ImagePicker imagePicker = ImagePicker();
                            //TODO allow user to select gallery OR camera
                            XFile? file = await imagePicker.pickImage(
                                source: ImageSource.camera);
          
                            if (file == null) return; //exit function if no image
                            String uniqueFileName =
                                DateTime.now().millisecondsSinceEpoch.toString();
          
                            imageUrl = await Get.put(ListingController())
                                .uploadImage(file, uniqueFileName);
          
                            //uploadedImage = NetworkImage(imageUrl);
          
                            //TODO refresh the page with the image we just uploaded
                          },
                          icon: Icon(Icons.camera_alt)),
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
                          keyboardType: TextInputType.number),
                      SizedBox(height: 10),
                      Text(
                        "Description",
                        style: myTextStyles.defaultText,
                      ),
                      TextFormField(
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        controller: descriptionController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        style: standardButton,
                        onPressed: () async {
                          //exit function if no image TODO update function for all fields
                          if (imageUrl == null) {
                            //TODO implement snackbar error instead of print
                            print("Upload Image (URL Null)");
                            return;
                          }
                          int timeIncrement =
                              int.parse(listingEndController.text[0]);
                          //TODO changed days in future to minutes to make testing easier, will go back on this later
                          DateTime newTime = new DateTime.now()
                              .add(Duration(minutes: timeIncrement));
                          int timestampInSeconds = newTime.millisecondsSinceEpoch;
          
                          final listing = ListingModel(
                            name: listingNameController.text,
                            hostID: FirebaseAuth.instance.currentUser!.uid,
                            endDate: timestampInSeconds,
                            tags: listingTagsController.getTags,
                            primaryImage: imageUrl!,
                            ticketPrice: int.parse(listingPriceController.text),
                            ticketsSold: 0,
                            usersWatching: 0,
                            usersInterested: 0,
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
          ),
        ),
        resizeToAvoidBottomInset: false);
  }
}
