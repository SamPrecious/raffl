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
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text('User: '),
            Text(user.email!),
            SizedBox(height: 60),
            ElevatedButton.icon(
              style: standardButton,
              onPressed: () {
                FirebaseAuth.instance.signOut();
                AutoRouter.of(context).push(SplashRoute());
              },
              icon: Icon(Icons.logout, size: 32),
              label: const Text('Log Out'),
            ),
          ],
        )
      )

    );
  }
}
