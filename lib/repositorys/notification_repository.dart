import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/notification_model.dart';



class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  //Notifications are a subcollection within userData
  createNotification(NotificationModel notificationData) async{
    await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).collection("Notifications")
        .doc(notificationData.getId()).set(notificationData.toFirestore()).whenComplete(
          () => print("Notification created"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }

  //Returns all notifications for current user
  Future<List<NotificationModel>> getNotifications() async {
    final snapshot = await db.collection("UserData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notifications").get();
    final notifications = snapshot.docs.map((e) =>
        NotificationModel.fromFirestore(e)).toList();
    return notifications;
  }
  /*
  Future<UserDataModel> getUserDetails(String uid) async {
    final snapshot = await db.collection("UserData")
        .where(FieldPath.documentId, isEqualTo: uid).get();
    final userData = snapshot.docs.map((e) =>
        UserDataModel.fromFirestore(e)).single;
    return userData;
  }
   */
}