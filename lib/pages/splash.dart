//The splash screen for Raffl
import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/widgets/auth_widget.dart';
import 'package:raffl/widgets/register_widget.dart';
import 'package:raffl/pages/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  bool isLogin = true;


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
              return Home();
            }else{
              return AuthWidget(onClickedSwapState: toggle, login: isLogin);
            }

          }
      ),
    );
    //If logged in this page should navigate us to the home screen
    //Otherwise this page should navigate us to the Login screen
  }
  void toggle(){
    print("TESTING");
    setState(() {
      isLogin = !isLogin;
    });
  }
  //void toggle() => setState(() => isLogin = !isLogin);
}
