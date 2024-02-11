import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:raffl/controllers/user_data_controller.dart';
import 'package:raffl/models/user_data_model.dart';

//This class handles initial access authentication (i.e. sign in, register)
class AccessAuth {

  static Future loginUser(BuildContext context, String email, String password) async {
    //TODO Maybe add a loading indicator here
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, e.message);
    }
  }

  static Future registerUser(BuildContext context, String email, String password) async {
    //TODO Maybe add a loading indicator here (or where this is called)

    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, e.message);
    }
    final user = FirebaseAuth.instance.currentUser!; //Gets user information
    final userData = UserDataModel(
      uid: user.uid,
      credits: 0,
    );
    //final userDataHandler = Get.put(UserDataHandler());
    //Creates data on FireStore with unique UID linked
    Get.put(UserDataController()).createUserData(userData);
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