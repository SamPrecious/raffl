import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:raffl/controllers/user_data_controller.dart';

class PushNotificationController {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final deviceToken = await firebaseMessaging.getToken(); //Gets the unique push notification for our device
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    await UserDataController().updateNotificationToken(deviceToken!);
  }

}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Title: ${message.notification?.body}");
  print("Payload: ${message.data}");
  //TODO Could navigate to the page of notification when pressed. I.e. if about a product, navigate to that product page?
}