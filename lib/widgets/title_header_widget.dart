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
    return Stack(
      alignment: Alignment.center,
      children: [
        //Using a row here allows us to center the back arrow
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                print("back");
                AutoRouter.of(context).pop();
                // Add any other actions you want to perform when the button is tapped
              },
            ),
          ],
        ),
        Text(title,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            )
        ),
      ],
    );
  }
}
