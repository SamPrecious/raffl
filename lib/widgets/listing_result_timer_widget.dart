import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:raffl/styles/colors.dart';
import 'package:raffl/widgets/custom_countdown_timer_widget.dart';

class ListingResultTimerWidget extends StatefulWidget {
  final int endTime;

  ListingResultTimerWidget({required this.endTime});

  @override
  _ListingResultTimerWidgetState createState() => _ListingResultTimerWidgetState();
}


class _ListingResultTimerWidgetState extends State<ListingResultTimerWidget> {

  Color containerColor = Colors.blue;
  bool isLessThanHour = false;
  void handleLessThanHour(isLessThanHour) {
    //Changes widget to red colour if we have less than an hour left
    if (isLessThanHour) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {  // Add this check
          setState(() {
            containerColor = Colors.red;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: containerColor,

      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: DefaultTextStyle(
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            child: CustomCountdownTimer(
              endTime: widget.endTime,
              lessThanHour: handleLessThanHour,
            ),
          ),
        ),
      ),
    );
  }
}