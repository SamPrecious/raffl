import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/standard_button.dart';

class TitleHeaderWidget extends StatelessWidget {
  //final Function press;
  final String title;

  TitleHeaderWidget({required this.title});

  //TODO Add more specific functionality to LoginButtonWidget or remove as its unnecessary right now

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, size: 30),
            onPressed: () {
              print("back");
              AutoRouter.of(context).pop();
            },
          ),
        ),
        Expanded(
          flex: 8,
          child: Align(
            alignment: Alignment.center,
            child: Text(title,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                )
            ),
          ),

        ),
        Expanded(
          flex: 1,
          child: Container(), // Empty container for the remaining space
        ),
      ],
    );

  }
}
