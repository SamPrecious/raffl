// Models the user
//TODO https://www.youtube.com/watch?v=LlQimtjqZ9A&list=PL5jb9EteFAODvqwaicjK4ZhzIKS6gtcd5&index=2 Reference video
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String uid;
  final int credits;

  const UserDataModel({
    required this.uid,
    required this.credits,
  });

  //maps data to JSON format for FireStore
  toFirestore(){
    return{
      "UID": uid,
      "Credits": credits,
    };
  }

  //Maps data from Firestore database to UserDataModel
  factory UserDataModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) { //SnapshotOptions? options <-Another argument you can add
    final data = snapshot.data()!; //TODO Remove or Keep !?
    return UserDataModel(
      uid: data["UID"],
      credits: data["Credits"],
    );
  }


}