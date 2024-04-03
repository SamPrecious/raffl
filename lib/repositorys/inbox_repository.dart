import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/notification_model.dart';



class InboxRepository extends GetxController {
  static InboxRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  //Notifications are a subcollection within userData
  createInboxEntry(NotificationModel notificationData, [String? userID]) async {
    String uid = userID ?? FirebaseAuth.instance.currentUser!.uid; //If user ID not provided, create for current user
    print("Creating notification for ${uid}");

    await db.collection("UserData").doc(uid).collection("Notifications")
        .doc(notificationData.getId()).set(notificationData.toFirestore()).whenComplete(
          () => print("Notification created"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  //Returns all notifications for current user
  Future<List<NotificationModel>> getInboxEntries() async {
    final snapshot = await db.collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notifications").get();
    final notifications = snapshot.docs.map((e) =>
        NotificationModel.fromFirestore(e)).toList();
    return notifications.reversed.toList(); //By doing reversed we are getting dates from most to least recent
  }
}