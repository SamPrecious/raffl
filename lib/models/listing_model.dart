import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ListingModel {
  final String? documentID;
  final String name;
  final int endDate;
  final List<String>? tags;

  const ListingModel({
    this.documentID,
    required this.name,
    required this.endDate,
    this.tags //Optional tags
  });


  //TODO - We don't need to retrieve tags BUT we want them to be queried with names, but nothing else
  //Maps data from Algolia JSON data to UserDataModel
  factory ListingModel.fromAlgolia(AlgoliaObjectSnapshot snapshot) { //SnapshotOptions? options <-Another argument you can add
    return ListingModel(
      documentID: snapshot.objectID,
      name: snapshot.data['Name'],
      endDate: snapshot.data['EndDate']
    );
  }

  toFirestore(){
    return{
      "Name": name,
      "EndDate": Timestamp.fromMillisecondsSinceEpoch(endDate),
      "Tags": tags
    };
  }

  factory ListingModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) { //SnapshotOptions? options <-Another argument you can add
    final data = snapshot.data()!;
    return ListingModel(
        documentID: snapshot.id,
        name: data['Name'],
        endDate: (data['EndDate'] as Timestamp).seconds,
        tags: data['Tags']?.cast<String>()
    );
  }

  @override
  String toString() {
    return '${documentID ?? 'No ID'} with name $name and date $endDate';
  }

  String getDocumentID() {
    return documentID ?? 'No ID';
  }

  String getName(){
    return '$name';
  }

  int getDate(){
    return endDate;
  }

  List<String> getTags() {
    return tags ?? []; //Returns empty array if tags is null
  }


}


