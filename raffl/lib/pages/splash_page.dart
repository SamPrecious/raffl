//The splash screen for Raffl
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../routes/app_router.gr.dart';

/*
This class is the splashscreen
It is what the app initially opens to, and routes us to relevant pages
 TODO Configure splashscreen
 */
@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

//AutoRouter.of(context).push(HomeRoute());
class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 10), () {
      AutoRouter.of(context).push(HomeRoute());
    });
    return MaterialApp(
      home: Scaffold(
        body: Center( // Add this widget
          // TODO replace load indicator with logo
            child: CircularProgressIndicator()
        ),
      ),
    );
  }
}

