import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//This class holds all of the account handling authentication (logins, register etc)
class AuthFunc {

  static Future loginUser(BuildContext context, String email, String password) async {
    //TODO Maybe add a loading indicator here
    print(email);
    print(password);

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
    //TODO Maybe add a loading indicator here
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
      )
  );
}