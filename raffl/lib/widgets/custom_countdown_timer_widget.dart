import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';


class CustomCountdownTimer extends StatelessWidget {
  final int endTime;
  final ValueChanged<bool>? lessThanHour;
  final ValueChanged<bool>? timesUp;
CustomCountdownTimer({required this.endTime, this.lessThanHour, this.timesUp});
  /*TODO
     Must add value to listen to tell us when timer ends, so we can refresh the page outside
   */
  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, endTime) {
        if(endTime == null) {
          if(lessThanHour != null && lessThanHour != true){
            lessThanHour!(true); //Tells owner that there is less than an hour left to set widget from blue to red
          }
          if(timesUp != null && timesUp != true){
            timesUp!(true);
          }
          return Text('Time\'s up!');
        } else {
          if(endTime.days != null){
            return Text('${endTime.days}d${endTime.hours != 0 ? ', ${endTime.hours}h' : ''}');
          }
          else if(endTime.hours != null){
            return Text('${endTime.hours}h${endTime.min != 0 ? ', ${endTime.min}m' : ''}');
          }
          else{
            if(lessThanHour != null && lessThanHour != true){
              lessThanHour!(true); //Tells owner that there is less than an hour left
            }
            if(endTime.min != null){
              return Text('${endTime.min}m${endTime.sec != 0 ? ', ${endTime.sec}s' : ''}');
            }
            else{
              return Text('${endTime.sec}s');
            }
          }

        }
      },
    );
  }
}