// Models the user
//TODO https://www.youtube.com/watch?v=LlQimtjqZ9A&list=PL5jb9EteFAODvqwaicjK4ZhzIKS6gtcd5&index=2 Reference video
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raffl/models/notification_model.dart';

class UserDataModel {
  final int credits;
  final String? notificationToken;
  //final List<NotificationDataModel> notifications;

  const UserDataModel({
    required this.credits,
    this.notificationToken,
  });

  //maps data to JSON format for FireStore
  toFirestore() {
    return {
      "Credits": credits,
    };
  }

  //Maps data from Firestore JSON data to UserDataModel
  factory UserDataModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!; //TODO Remove or Keep !?
    return UserDataModel(
      credits: data["Credits"],
      notificationToken: data["NotificationToken"],
    );
  }
}
