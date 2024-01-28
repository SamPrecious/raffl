//The splash screen for Raffl
import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/widgets/auth_widget.dart';
import 'package:raffl/widgets/register_widget.dart';
import 'package:raffl/pages/home_page.dart';
import 'package:raffl/pages/auth_page.dart';

/*
This class is the splashscreen
It is what the app initially opens to, and routes us to relevant pages
 */
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(), //Determines if user is logged in
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator()); //Loading wheel while waiting
            }
            else if(snapshot.hasError){
              return Center(child: Text('Error Occured')); //Error while signing in
            }
            else if(snapshot.hasData){ //If user is logged in
              return HomePage();
            }else{
              //TODO Move widget to seperate Authentication page?
              return AuthPage();
            }

          }
      ),
    );
    //If logged in this page should navigate us to the home screen
    //Otherwise this page should navigate us to the Login screen
  }
}
