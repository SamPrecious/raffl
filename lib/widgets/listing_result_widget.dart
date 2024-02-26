import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/styles/text_styles.dart';
import 'package:raffl/widgets/custom_countdown_timer_widget.dart';
import 'package:raffl/widgets/listing_result_timer_widget.dart';

class ListingResultWidget extends StatelessWidget {
  final String name;
  final int endDate;
  final String primaryImageUrl;

  const ListingResultWidget(
      {Key? key,
      required this.name,
      required this.endDate,
      required this.primaryImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 180;
    final double topContainerHeight = containerHeight * 0.8;
    final double lineHeight =
        containerHeight * 0.0075; //Lines take up width of 0.02
    final double bottomContainerHeight = containerHeight * 0.1850;

    return Container(
        height: containerHeight, //Height of each individual widget
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //Top widget
          Flexible(
            fit: FlexFit.tight,
            flex: 8000,
            child: Row(
              children: [
                //Image widget taking up 35% width
                Flexible(
                  fit: FlexFit.tight,
                  flex: 45,
                  child: Container(
                    color: Colors.blue,
                    constraints: BoxConstraints(
                      minHeight: topContainerHeight,
                      maxHeight: topContainerHeight,
                    ),
                    child: Image.network(primaryImageUrl, fit: BoxFit.cover),
                  ),
                ),
                //Descriptive widget taking up 65% width
                Flexible(
                  fit: FlexFit.tight, // change this from loose to tight
                  flex: 55,
                  child: Container(
                    color: secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Testing",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ), //Descriptive stuff
                  ),
                ),
              ],
            ),
          ),
          //Draws black line
          Flexible(
            fit: FlexFit.tight,
            flex: 75,
            child: Container(
              color: Colors.black,
            ),
          ),
          //Bottom widget
          Flexible(
              fit: FlexFit.tight,
              flex: 1850,
              child: Row(children: [
                //Name widget taking up 75% width
                Flexible(
                  fit: FlexFit.tight, // change this from loose to tight
                  flex: 75,
                  child: Container(
                    color: secondaryColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(name,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                ),
                //Countdown widget taking up 25% width
                Flexible(
                  fit: FlexFit.tight, // change this from loose to tight
                  flex: 25,
                  child: ListingResultTimerWidget(endTime: endDate),
                ),
              ])),
          Flexible(
            fit: FlexFit.tight,
            flex: 75,
            child: Container(
              color: Colors.black,
            ),
          ),
        ]));
  }
}
