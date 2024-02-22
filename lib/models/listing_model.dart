import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListingModel {
  final String? documentID;
  final String? hostID;
  final String name;
  final int endDate;
  final List<String>? tags;
  final String primaryImage;
  final String? description;

  const ListingModel({
    this.documentID,
    this.hostID,
    required this.name,
    required this.endDate,
    this.tags,
    required this.primaryImage,
    this.description,
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
    };
  }

  factory ListingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) { //SnapshotOptions? options <-Another argument you can add
    final data = snapshot.data()!;
    return ListingModel(
      documentID: snapshot.id,
      name: data['Name'],
      hostID: data['HostID'],
      endDate: (data['EndDate'] as Timestamp).seconds,
      tags: data['Tags']?.cast<String>(),
      primaryImage: data['PrimaryImage'],
    );
  }

  @override
  String toString() {
    return '${documentID ?? 'No ID'} with name $name and date $endDate';
  }

  String getHostID() {
    return hostID ?? 'No Owner ID';
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

  String getDescription(){
    return description ?? "No Description";
  }

  int getDate(){
    return endDate;
  }

  List<String> getTags() {
    return tags ?? []; //Returns empty array if tags is null
  }


}


