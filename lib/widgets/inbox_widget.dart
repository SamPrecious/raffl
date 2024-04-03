import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:intl/intl.dart';

class InboxWidget extends StatelessWidget {
  final String inboxID; //This is the date
  final String
      listingID; //Used to link us back to the page for the notification
  final String inboxName;
  final String imageUrl;
  final String inboxDesc;

  const InboxWidget({
    Key? key,
    required this.inboxID,
    required this.listingID,
    required this.inboxName,
    required this.imageUrl,
    required this.inboxDesc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 100;
    final double notificationHeight = containerHeight * 0.8;
    //Image height and width for 4:3 image
    final double imageHeight = notificationHeight * 0.85;
    final double imageWidth = imageHeight * 4/3;
    return Container(
      height: containerHeight,
      child: Column(
        children: [
           Align(
             alignment: Alignment.centerRight,
               child: Text(
                   style: myTextStyles.fadedTextSmall,
                   DateFormat('dd/MM/yy - mm:HH').format(DateTime.fromMillisecondsSinceEpoch(int.parse(inboxID))))
           ),
          Container(
            constraints: BoxConstraints(
              minHeight: notificationHeight,
              maxHeight: notificationHeight,
            ),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 40,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(inboxName,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 60,
                          child:  Align(
                            alignment: Alignment.centerLeft,
                            child: Text(inboxDesc,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.network(imageUrl, fit: BoxFit.cover)
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
