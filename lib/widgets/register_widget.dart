import 'package:flutter/material.dart';
import 'package:raffl/widgets/register_button_widget.dart';
import 'package:raffl/widgets/register_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raffl/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/register_button_widget.dart';

class RegisterWidget extends StatefulWidget {
  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}


class _RegisterWidgetState extends State<RegisterWidget> {
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
              const Text('REGISTER MAN'),
              TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  )
              ),
              //ElevatedButton.styleFrom
              RegisterButtonWidget(onPressed: (){
                registerUser();
                print(nameController.text);},
              ),
              const SizedBox(height: 40),
              RegisterButtonWidget(onPressed: (){
                registerUser();
                print(nameController.text);}
              )
            ],
          ),



        )
    );
  }
  Future registerUser() async {

  }
}


