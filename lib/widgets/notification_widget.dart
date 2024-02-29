import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/listing_result_timer_widget.dart';

class NotificationWidget extends StatelessWidget {
  final String notifID; //This is the date
  final String
      listingID; //Used to link us back to the page for the notification
  final String notifName;
  final String imageUrl;
  final String notifDesc;

  const NotificationWidget({
    Key? key,
    required this.notifID,
    required this.listingID,
    required this.notifName,
    required this.imageUrl,
    required this.notifDesc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final double containerHeight = 100;
    final double notificationSize = containerHeight * 0.8;

    return Container(
      height: containerHeight,
      child: Column(
        children: [
          //TODO Text aligned right with date

          Text(DateTime.fromMicrosecondsSinceEpoch(int.parse(notifID)).toString()),
          //Box that takes up whole area
          Container(
            constraints: BoxConstraints(
              minHeight: notificationSize,
              maxHeight: notificationSize,
            ),
            decoration: BoxDecoration(
              color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(notifName,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(notifDesc,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    ),
                  ],
                ),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 45,
                  child: Container(
                    color: Colors.blue,
                    constraints: BoxConstraints(
                      minHeight: notificationSize,
                      maxHeight: notificationSize,
                    ),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
              ],


            ),
          )
        ],
      ),
    );
  }
}
