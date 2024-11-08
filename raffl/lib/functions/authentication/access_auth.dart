import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/push_notification_controller.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/user_data_model.dart';

//This class handles initial access authentication (i.e. sign in, register)
class AccessAuth {

  static Future loginUser(BuildContext context, String email, String password) async {
    //TODO Maybe add a loading indicator here
    try {
      UserCredential userDetails = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logging user IN");

      final User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print('Logged in user is ${user.email}');
      } else {
        print('No user is currently logged in.');
      }


      //await userDetails;
      //await PushNotificationController().initNotifications(); //Call this on every login in-case token changes
      //return true;

      if (!userDetails.user!.emailVerified) { //Sign out and show error if not verified
        await FirebaseAuth.instance.signOut();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email before login.'),
          ),
        );
        return false;
      }
      else{ //Login successful
        await PushNotificationController().initNotifications(); //Call this on every login in-case token changes
        return true;
      }

    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, e.message);
    }
  }

  static Future registerUser(BuildContext context, String email, String password) async {
    //TODO Maybe add a loading indicator here (or where this is called)

    try{
      UserCredential userDetails = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Registering User");

      await userDetails;

      await userDetails.user!.sendEmailVerification(); //Sends email verification to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Awaiting email verification.'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, e.message);
    }
    final userData = UserDataModel(
      credits: 0,
      //notifications: [],
    );
    //Creates data on FireStore with unique UID linked
    //TODO Utilise Get controller with Get.find<UserDataController> which avoids us passing the same value around OR remove usage
    Get.put(UserDataController()).createUserData(userData);
    try{
      await PushNotificationController().initNotifications();
    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, e.message);
    }
  }
}

void showFlashError(BuildContext context, String? message){
  if(message == null) return;
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      )
  );
}