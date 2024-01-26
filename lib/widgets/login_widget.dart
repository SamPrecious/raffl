import 'package:flutter/material.dart';
import 'package:raffl/widgets/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raffl/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/styles/standard_button.dart';

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}


class _LoginWidgetState extends State<LoginWidget> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var password;
    return Scaffold(
        body: SafeArea(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Enter Username/Email'),
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Username/Email',
                  )
              ),
              const SizedBox(height: 10),
              const Text('Enter Password'),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  )
              ),
              ElevatedButton(onPressed: (){
                logUserIn();
                print(nameController.text);},
                  style: standardButton,
                  child: const Text('Go to login')
              )
            ],
          ),
          /*
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded( //Border to left of content
                flex: 20, // 20%
                child: Container(), //Add colour to visualise border: color: Colors.red
              ),
              Expanded( //Interior content
                flex: 60, // 60%
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Enter Username/Email'),
                    TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: 'Username/Email',
                        )
                    ),
                    const SizedBox(height: 10),
                    const Text('Enter Password'),
                    TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                        )
                    ),
                    TextButton(onPressed: (){
                      logUserIn();
                      print(nameController.text);},
                        child: const Text('Go to login')
                    )
                  ],
                ),
              ),
              Expanded( //Border to right of content
                flex: 20, // 20%
                child: Container(),
              )
            ],
          ),*/


        )
    );
  }
  Future logUserIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: nameController.text.trim(),
        password: passwordController.text.trim(),
    );
  }
}


