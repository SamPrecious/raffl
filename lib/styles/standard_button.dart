import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';

/*
https://www.youtube.com/watch?v=RGq_mshw9yM

TODO:
maybe rename this to 'buttons'
And have multiple button styles
To abstract further, we can have each button style in its own button file
and just use this to access them like a getter
*/

final ButtonStyle standardButton = ElevatedButton.styleFrom(
  minimumSize: const Size(150,25),
  padding: const EdgeInsets.all(12.0),
  backgroundColor: secondaryColor,
  foregroundColor: primaryColor,
  elevation: 1, //Lookup what this does
);