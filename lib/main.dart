import 'package:flutter/material.dart';
import 'package:raffl/pages/home.dart';
import 'package:raffl/pages/login.dart';
import 'package:raffl/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raffl/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/widgets/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Waits until Firebase is initiated to load widgets
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance
      .authStateChanges()
      .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  runApp(MaterialApp(
    routes: { //Routes us to our pages
      '/': (context) => Splash(), //This can decide if we go to Login or Home
      '/home': (context) => Home(),
      '/login': (context) => Login(),
    },
  ));
}

