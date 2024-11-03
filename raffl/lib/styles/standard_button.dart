import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';



final ButtonStyle standardButton = ElevatedButton.styleFrom(
  minimumSize: const Size(150,25),
  padding: const EdgeInsets.all(12.0),
  backgroundColor: secondaryColor,
  foregroundColor: primaryColor,
  elevation: 1,
);

final ButtonStyle circularButton = IconButton.styleFrom(
  minimumSize: const Size(25,25),
  backgroundColor: secondaryColor,
  foregroundColor: primaryColor,
  elevation: 1,
);
