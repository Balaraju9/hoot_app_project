import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';

class TimeCounter extends StatelessWidget{
  final VoidCallback? onDone;
  final Duration? duration;
  const TimeCounter({super.key,this.onDone,this.duration});

  @override
  Widget build(BuildContext context) {
    return SlideCountdown(
      onDone: onDone,
      duration: duration,
      onChanged: (val){
        
      },
    );
  }
}