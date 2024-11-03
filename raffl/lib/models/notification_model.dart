import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {

  final String id;
  /*
  Listing ID currently optional
  This is incase we have notifications unrelated to listings
   */
  final String? listingID;
  final String notificationName; //Same name as item, if related to item
  final String imageUrl;
  final String description;

  const NotificationModel({
    required this.id,
    this.listingID,
    required this.notificationName,
    required this.imageUrl,
    required this.description,
  });

  getId(){
    return id;
  }
  getNotificationID() {
    return id;
  }

  getListingID() {
    return listingID;
  }

  getName(){
    return notificationName;
  }

  getImageUrl() {
    return imageUrl;
  }

  getDescription() {
    return description;
  }


  //maps data to JSON format for FireStore
  toFirestore() {
    return {
      "ListingID": listingID,
      "ListingName": notificationName,
      "Image": imageUrl,
      "Description": description,
    };
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return NotificationModel(
      id: snapshot.id, //todo CHANGE!
      notificationName: data["ListingName"],
      imageUrl: data["Image"],
      listingID: data["ListingID"],
      description: data["Description"]
    );
  }
  @override
  String toString() {
    return 'NotificationModel{id: $id, notificationName: $notificationName, imageUrl: $imageUrl, listingID: $listingID, description: $description}';
  }

}
