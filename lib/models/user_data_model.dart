// Models the user
//TODO https://www.youtube.com/watch?v=LlQimtjqZ9A&list=PL5jb9EteFAODvqwaicjK4ZhzIKS6gtcd5&index=2 Reference video
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:raffl/models/notification_model.dart';

class UserDataModel {
  final int credits;
  final String? notificationToken;
  final List<String>? watching;
  final List<String>? recentlyViewed;

  const UserDataModel({
    required this.credits,
    this.notificationToken,
    this.watching,
    this.recentlyViewed
  });

  //maps data to JSON format for FireStore
  toFirestore() {
    return {
      "Credits": credits,
    };
  }

  //Maps data from Firestore JSON data to UserDataModel
  factory UserDataModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    print("Watching is: ${data["Watching"]}");
    return UserDataModel(
      credits: data["Credits"],
      notificationToken: data["NotificationToken"],
      watching: data["Watching"] != null ? List<String>.from(data["Watching"].map((item) => item as String)) : [],
      recentlyViewed: data["RecentlyViewed"] != null ? List<String>.from(data["RecentlyViewed"].map((item) => item as String)) : [],
    );
  }
}

