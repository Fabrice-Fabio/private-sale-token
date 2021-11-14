import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatefulWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: LinearPercentIndicator(
        width: MediaQuery.of(context).size.width/2,
        animation: true,
        lineHeight: 20.0,
        animationDuration: 2000,
        percent: 0.9,
        center: const Text("90.0%", style: TextStyle(color: Colors.white),),
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: Colors.deepOrange,
        leading: Text('0 ', style: TextStyle(color: Colors.deepOrange)),
        trailing: Text(' 120', style: TextStyle(color: Colors.deepOrange)),
      ),
    );
  }
}
