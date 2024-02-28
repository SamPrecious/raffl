class NotificationDataModel {
  final String id;
  /*
  Listing ID currently optional
  This is incase we have notifications unrelated to listings
   */
  final String? listingID;
  final String notificationName; //Same name as item, if related to item
  final String imageUrl;
  final String description;

  const NotificationDataModel({
    required this.id,
    this.listingID,
    required this.notificationName,
    required this.imageUrl,
    required this.description,
  });


  getId(){
    return id;
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
}
