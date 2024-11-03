import 'package:flutter/material.dart';
import 'package:raffl/styles/standard_button.dart';


class RegisterButtonWidget extends StatelessWidget {
  //final Function press;
  final GestureTapCallback onPressed;
  RegisterButtonWidget({required this.onPressed});

  //TODO Add more specific functionality to RegisterButtonWidget or remove as its unnecessary right now

  @override
  Widget build(BuildContext context){
    return ElevatedButton(
        style: standardButton,
        onPressed: onPressed,
        child: const Text('Register'));
  }



}