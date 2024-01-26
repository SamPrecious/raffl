//The home screen for Raffl
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/styles/standard_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

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
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout, size: 32),
              label: const Text('Log Out'),
            ),
          ],
        )
      )

    );
  }
}
