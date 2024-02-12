//The home screen for Raffl
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/standard_button.dart';


@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!; //Gets user information

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Text('User: '),
                  Text(user.email!),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: standardButton,
                    onPressed: () {
                      AutoRouter.of(context).push(ProfileRoute());
                    },
                    icon: Icon(Icons.person_rounded, size: 32),
                    label: const Text('Profile'),
                  ),
                ],
              ),
            )
          ),
          BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Watching',
                ),

              ]),
        ],
      )

    );
  }
}
