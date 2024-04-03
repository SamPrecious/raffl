import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';

class myTextStyles{
  static final defaultText = TextStyle(
      fontSize: 16
  );
  static final fadedText = TextStyle(
      fontSize: 16,
      color: secondaryColorFaded
  );
  static final fadedTextSmall = TextStyle(
      fontSize: 14,
      color: secondaryColorFaded
  );
  static final titleText = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: secondaryColor,
  );
}