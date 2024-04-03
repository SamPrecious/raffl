import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:get/get.dart';
import 'package:raffl/models/notification_model.dart';

class PushNotificationController extends GetxController{
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final deviceToken = await firebaseMessaging.getToken(); //Gets the unique push notification for our device
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await UserDataController().updateNotificationToken(deviceToken!);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received notification with message: ${message.data} and data ${message.notification}');
    });

  }

  Future<void> sendPushNotification(String userID, NotificationModel notification) async{
    print("Sending push notification");
    await FirebaseFunctions.instanceFor(region: 'europe-west2').httpsCallable('addPushNotification').call(
      {
        "userID": userID,
        "notificationName": notification.getName(),
        "imageUrl": notification.getImageUrl(),
        "listingID": notification.getListingID(),
        "description": notification.getDescription(),
      },
    );
    print("notification sent");
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Description: ${message.notification?.body}");
  //TODO Could navigate to the page of notification when pressed. I.e. if about a product, navigate to that product page?
}