import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';


class LoginButtonWidget extends StatelessWidget {
  //final Function press;
  final GestureTapCallback onPressed;
  LoginButtonWidget({required this.onPressed});

  //TODO Add more specific functionality to LoginButtonWidget or remove as its unnecessary right now

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        style: standardButton,
        onPressed: onPressed,
        child: const Text('Login'));
  }



}