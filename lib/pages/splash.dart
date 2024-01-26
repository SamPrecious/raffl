//The splash screen for Raffl
import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  print("GO to login");
                  Navigator.pushNamed(context, '/login');
                },
                style: standardButton,
                child: const Text('Go to login'),

              ),
            ],
          )),
    );

    //If logged in this page should navigate us to the home screen
    //Otherwise this page should navigate us to the Login screen
  }
}
