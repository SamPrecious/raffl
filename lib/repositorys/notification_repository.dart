import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/models/notification_data_model.dart';



class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find(); //Static instance of all getx controllers
  final db = FirebaseFirestore.instance;

  //Notifications are a subcollection within userData
  createNotification(NotificationDataModel notificationData) async{
    await db.collection("UserData").doc(FirebaseAuth.instance.currentUser!.uid).collection("Notifications")
        .doc(notificationData.getId()).set(notificationData.toFirestore()).whenComplete(
          () => print("Notification created"),
    ).catchError((error, stackTrace) {
      throw Exception(error.toString());
    });
  }
}