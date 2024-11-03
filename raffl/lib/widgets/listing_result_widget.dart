import 'package:flutter/material.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/listing_result_timer_widget.dart';

class ListingResultWidget extends StatelessWidget  {
  final String name;
  final int endDate;
  final String primaryImageUrl;
  final int ticketsSold;
  final int usersInterested;
  final int views;
  final int ticketPrice;
  final bool? includeTimer;
  const ListingResultWidget(
      {Key? key,
      required this.name,
      required this.endDate,
        required this.primaryImageUrl,
        required this.ticketsSold,
        required this.usersInterested,
        required this.views,
        required this.ticketPrice,
        this.includeTimer = true, //Default to true
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double containerHeight = 180;
    final double topContainerHeight = containerHeight * 0.8;
    final double lineHeight = containerHeight * 0.0075; //Lines take up width of 0.02
    final double bottomContainerHeight = containerHeight * 0.1850;

    //Image height is the top container height and width for 4:3 image
    final double imageWidth = topContainerHeight * 4/3;

    return Container(
        height: containerHeight, //Height of each individual widget
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          //Top widget
          Flexible(
            fit: FlexFit.tight,
            flex: 8000,
            child: Row(
              children: [
                Container(
                  color: Colors.blue,
                  height: topContainerHeight,
                  width: imageWidth,
                  child: Image.network(primaryImageUrl, fit: BoxFit.cover),
                ),
                //Descriptive widget detailing extra stats
                Expanded(
                  child: Column(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Tickets Sold: ${ticketsSold}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                          ), //Descriptive stuff
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Users Interested: ${usersInterested}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                          ), //Descriptive stuff
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Ticket Price: £${ticketPrice}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                          ), //Descriptive stuff
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 1,
                        child: Container(
                          color: secondaryColor,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Views: ${views}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )
                              ),
                            ),
                          ), //Descriptive stuff
                        ),
                      ),
                    ],
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
                if (includeTimer == true) ... [ //Optional as we don't include it on our wins page, as its always already over
                  Flexible(
                    fit: FlexFit.tight, // change this from loose to tight
                    flex: 25,
                    child: ListingResultTimerWidget(endTime: endDate),
                  ),
                ],
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
