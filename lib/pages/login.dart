//The login screen for Raffl
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raffl/widgets/login_widget.dart';
import 'package:raffl/pages/home.dart';

class Login extends StatelessWidget {
  //const Login({super.key});
  /*
  TODO
  Remove page and use splash screen instead
  OR
  Move some functionality into splash screen and keep this page (if useful)
  NOTE: Probably do this one, as seperating Register button may be optimal
  https://www.youtube.com/watch?v=4vKiJZNPhss

  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              /*
              TODO:
              Add extra cases for errors and stuff
               */
              if(snapshot.hasData){
                return Home();
              }else{
                return LoginWidget();
              }

            }
        ),
    );
        /*
    return Scaffold(
        body: SafeArea(
          child: Text('Test'),

        )
    );*/
      /*
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            if(snapshot.hasData){
              print("Go home kid");
              //return Home();
              ///home': (context) => Home()
              return Login();
            }
            else{
              print("WRONG!");
              return Login();
            }

          }
        )*/

  }
}




