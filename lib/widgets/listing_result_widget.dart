import 'package:flutter/material.dart';

class ListingResultWidget extends StatelessWidget {
  final String name;
  final int endDate;

  const ListingResultWidget({Key? key, required this.name, required this.endDate}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        color: Colors.blue[200],
        child: Row(
          children: [
            Text(name),
            SizedBox(width: 50),
            Text(endDate.toString())
          ],
        ),
      ),
    );
  }
}