import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:raffl/routes/app_router.gr.dart';
import 'package:raffl/styles/standard_button.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!; //Gets user information

    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 120),
                  Text('User: '),
                  Text(user.email!),
                  Text('UID: '),
                  Text(user.uid),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: standardButton,
                    onPressed: () {
                      AutoRouter.of(context).push(HomeRoute());
                    },
                    icon: Icon(Icons.home, size: 32),
                    label: const Text('Home'),
                  ),
                ],
              ),
            )
        )

    );
  }
}
