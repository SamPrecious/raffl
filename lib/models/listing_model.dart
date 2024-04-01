import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raffl/models/address_model.dart';
import 'package:raffl/models/shipping_details_model.dart';


class ListingModel {
  final String? documentID;
  final String? hostID;
  final String name;
  final int endDate;
  final List<String>? tags;
  final String primaryImage;
  final String? description;
  final int? ticketPrice;
  final int? ticketsOwned; //Tickets owned by current user
  final String? winner;
  final int? ticketsSold;
  final int? usersWatching;
  final int? usersInterested;
  final int? views;
  final AddressModel? address;
  final ShippingDetailsModel? shippingDetails;
  final bool? itemReceived;

  const ListingModel({
    this.documentID,
    this.hostID,
    required this.name,
    required this.endDate,
    this.tags,
    required this.primaryImage,
    this.description,
    this.ticketPrice,
    this.ticketsOwned,
    this.winner,
    this.ticketsSold,
    this.usersWatching,
    this.usersInterested,
    this.views,
    this.address,
    this.shippingDetails,
    this.itemReceived,
  });



  //TODO - We don't need to retrieve tags BUT we want them to be queried with names, but nothing else
  //Maps data from Algolia JSON data to UserDataModel
  factory ListingModel.fromAlgolia(AlgoliaObjectSnapshot snapshot) { //SnapshotOptions? options <-Another argument you can add
    return ListingModel(
      documentID: snapshot.objectID,
      name: snapshot.data['Name'],
      endDate: snapshot.data['EndDate'],
      primaryImage: snapshot.data['PrimaryImage']
    );
  }

  toFirestore(){
    return{
      "Name": name,
      "HostID": hostID,
      "EndDate": Timestamp.fromMillisecondsSinceEpoch(endDate),
      "Tags": tags,
      "PrimaryImage": primaryImage,
      "Description": description,
      "TicketPrice": ticketPrice,
      "TicketsSold": ticketsSold,
      "UsersWatching": usersWatching,
      "UsersInterested": usersInterested,
      "Views:": views,
    };
  }


  factory ListingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, int ticketsOwned) { //SnapshotOptions? options <-Another argument you can add
    final data = snapshot.data()!;
    return ListingModel(
      documentID: snapshot.id,
      name: data['Name'],
      hostID: data['HostID'],
      endDate: (data['EndDate'] as Timestamp).millisecondsSinceEpoch,
      tags: data['Tags']?.cast<String>(),
      primaryImage: data['PrimaryImage'],
      ticketPrice: data['TicketPrice'],
      ticketsOwned: ticketsOwned,
      winner: data['Winner'],
      description: data['Description'],
      ticketsSold: data['TicketsSold'],
      usersWatching: data['UsersWatching'],
      usersInterested: data['UsersInterested'],
      views: data['Views'],
      address: data['Address'] != null ? AddressModel.fromFirestore(data['Address']) : null,
      shippingDetails: data['ShippingDetails'] != null ? ShippingDetailsModel.fromFirestore(data['ShippingDetails']) : null,
      itemReceived: data['ItemReceived'],
    );
  }

  bool hasAddress() {
    return address != null; //Return true if has address, false otherwise
  }

  bool hasShippingDetails(){
    return shippingDetails != null; //todo
  }

  bool hasBeenReceived(){
    return itemReceived ?? false;
  }

  @override
  String toString() {
    return '${documentID ?? 'No ID'} with name $name and date $endDate';
  }

  AddressModel? getAddress(){
    return address;
  }

  ShippingDetailsModel? getShippingDetails(){
    return shippingDetails;
  }

  String getWinnerID(){
    return winner ?? "invalid";
  }
  String getHostID() {
    return hostID ?? 'No Owner ID';
  }

  int getTicketsOwned() {
    return ticketsOwned ?? 0;
  }
  String getDocumentID() {
    return documentID ?? 'No Document ID';
  }

  String getName(){
    return '$name';
  }

  String getPrimaryImageURL(){
    return '$primaryImage';
  }

  int getTicketPrice(){
    return ticketPrice ?? 0;
  }

  int getTicketsSold(){
    return ticketsSold ?? 0;
  }

  int getUsersWatching(){
    return usersWatching ?? 0;
  }

  int getUsersInterested(){
    return usersInterested ?? 0;
  }
  String getDescription(){
    print("Description is: ${description}");
    return description ?? "No Description";
  }

  int getDate(){
    print("Returning date: $endDate");
    return endDate;
  }

  List<String> getTags() {
    return tags ?? []; //Returns empty array if tags is null
  }


}


