//The splash screen for Raffl
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/widgets/auth_widget.dart';
import 'package:raffl/widgets/register_widget.dart';
import 'package:raffl/pages/home_page.dart';
import 'package:raffl/pages/auth_page.dart';

import '../routes/app_router.gr.dart';
import '../routes/guard/auth_guard.dart';

/*
This class is the splashscreen
It is what the app initially opens to, and routes us to relevant pages
 */
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
/*
  @override
  void initState() {
    super.initState();
    // Listen to the authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      // If the user is logged in, replace the current page with the HomeRoute
      if (user != null) {
        AutoRouter.of(context).replace(HomeRoute());
      }
      // If the user is not logged in, replace the current page with the AuthRoute
      else {
        //AutoRouter.of(context).replace(HomeRoute());
        AutoRouter.of(context).replace(AuthRoute());
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            child: const Text('Goto X Page'),
            onPressed: (){
              //AutoRouter.of(context).push(AuthRoute());
              AutoRouter.of(context).push(HomeRoute());
            }

          )
        ],
      ),
      /*
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          //Determines if user is logged in
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child:
                  CircularProgressIndicator()); //Loading wheel while waiting
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error Occured')); //Error while signing in
            } else if (snapshot.hasData) {
              //If user is logged in
              print("Testing");
              AutoRouter.of(context).push(HomeRoute());
              return Container();
              //return HomePage();
            } else {
              //TODO Move widget to seperate Authentication page?

              AutoRouter.of(context).push(AuthRoute());
              return Container();
            }
          }),*/
    );
    //If logged in this page should navigate us to the home screen
    //Otherwise this page should navigate us to the Login screen
  }
}
