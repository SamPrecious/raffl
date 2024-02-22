import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';

class ListingResultWidget extends StatelessWidget {
  final String name;
  final int endDate;
  final String primaryImageUrl;

  const ListingResultWidget({Key? key, required this.name, required this.endDate, required this.primaryImageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: secondaryColor,
          border: Border(
            left: BorderSide(
              width: 1,
              color: Colors.black,
            ),
            right: BorderSide(
              width: 1,
              color: Colors.black,
            ),
              top: BorderSide(
                width: 1,
                color: Colors.black,
              )
          )
        ),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )
            ),
            SizedBox(width: 50),
            Text(
                endDate.toString(),
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )
            ),
            SizedBox(width: 20),
            Image.network(primaryImageUrl),

          ],
        ),
      ),

    );
  }
}