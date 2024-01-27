import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:raffl/widgets/login_button_widget.dart';
import 'package:raffl/widgets/auth_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raffl/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raffl/styles/standard_button.dart';
import 'package:raffl/widgets/register_button_widget.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:email_validator/email_validator.dart';

class AuthWidget extends StatefulWidget {
  final bool login;
  final VoidCallback onClickedSwapState; //If the user clicked the 2nd button (register or login)
  const AuthWidget({Key? key, required this.login, required this.onClickedSwapState}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}


class _AuthWidgetState extends State<AuthWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var password;
    return Scaffold(
        body: SafeArea(
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                widget.login ?
                "Log In":"Register",
                style: myTextStyles.titleText,
              ),
              const SizedBox(height: 40),
              const Text('Enter Email'),
              TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                  ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email) //Checks email is valid
                  ? 'Enter a valid email'
                        : null,
              ),
              const SizedBox(height: 10),
              const Text('Enter Password'),
              TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length <= 4
                  ? 'Enter 4 characters minimum'
                : null
              ),
              ElevatedButton(onPressed: (){
                if(widget.login){
                  logUserIn();
                }
                else{
                  registerUser();
                }
                print(emailController.text);
                },
                style: standardButton,
                child: widget.login ? //If Login mode, Login is first button
                Text('Login') : Text('Register')
              ),
              const SizedBox(height: 40),
              ElevatedButton(onPressed: (){
                print(emailController.text);
                print('${widget.login}');
                widget.onClickedSwapState(); //Indicates that we clicked to swap state
                },
                  style: standardButton,
                  child: widget.login ? //If Login mode, Register is second button
                  Text('Register') : Text('Login')
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
    //TODO Maybe add a loading indicator here? Maybe move to another class?
    //TODO Add error message if failure for user? Like a pop up or something
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future registerUser() async {
    //TODO Maybe add a loading indicator here? Maybe move to another class?
    //TODO Add error message if failure for user? Like a pop up or something
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showFlashError(context, "error");
      //Utils.showSnackBar(e.message);
    }


  }

}

void showFlashError(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    )
  );
}


