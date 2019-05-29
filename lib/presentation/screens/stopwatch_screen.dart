import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StopwatchScreen extends StatefulWidget {
  final String title;

  StopwatchScreen({Key key, this.title}) : super(key: key);

  @override
  _StopwatchScreenState createState() => new _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Stopwatch stopwatch = new Stopwatch();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new StopwatchWidgetText(
                stopwatch: stopwatch,
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildFloatingButton(
                  stopwatch.isRunning ? 'lap' : 'reset',
                  leftButtonPressed,
                  'leftButton',
                ),
                buildFloatingButton(
                  stopwatch.isRunning ? 'stop' : 'start',
                  rightButtonPressed,
                  'rightButton',
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar(),
    );
  }

  void leftButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        print('${stopwatch.elapsedMilliseconds}');
      } else
        stopwatch.reset();
    });
  }

  void rightButtonPressed() {
    setState(() {
      if (stopwatch.isRunning)
        stopwatch.stop();
      else
        stopwatch.start();
    });
  }

  Widget buildFloatingButton(
      String text, VoidCallback callback, String heroTag) {
    TextStyle textStyle = new TextStyle(
      fontSize: 16.0,
      color: Colors.white,
    );
    return new FloatingActionButton(
      onPressed: callback,
      child: new Text(
        text,
        style: textStyle,
      ),
      heroTag: heroTag,
    );
  }

  _StopwatchScreenState();
}

class StopwatchWidgetText extends StatefulWidget {
  final Stopwatch stopwatch;

  @override
  State<StopwatchWidgetText> createState() =>
      new _StopwatchWidgetTextState(stopwatch);

  StopwatchWidgetText({this.stopwatch});
}

class _StopwatchWidgetTextState extends State<StopwatchWidgetText> {
  final Stopwatch stopwatch;
  Timer timer;

  _StopwatchWidgetTextState(this.stopwatch) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 72.0,
      fontFamily: "Open Sans",
    );
    String formattedTime =
        StopwatchTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}

class StopwatchWidgetLapText extends StatefulWidget {
  final Stopwatch stopwatch;

  @override
  State<StopwatchWidgetLapText> createState() =>
      new _StopwatchWidgetLapTextState(stopwatch);

  StopwatchWidgetLapText({this.stopwatch});
}

class _StopwatchWidgetLapTextState extends State<StopwatchWidgetLapText> {
  final Stopwatch stopwatch;
  Timer timer;

  _StopwatchWidgetLapTextState(this.stopwatch) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 30.0,
      fontFamily: "Open Sans",
    );
    String formattedTime =
        StopwatchTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}
/*class StopwatchWidgetSubText extends StatefulWidget {
  final Stopwatch stopwatch;

  @override
  State<StopwatchWidgetSubText> createState() =>
      new _StopwatchWidgetSubTextState(stopwatch);

  StopwatchWidgetSubText({this.stopwatch});
}

class _StopwatchWidgetSubTextState extends State<StopwatchWidgetSubText> {
  final Stopwatch stopwatch;
  Timer timer;

  _StopwatchWidgetSubTextState(this.stopwatch) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 72.0,
      fontFamily: "Open Sans",
    );
    String formattedTime =
    StopwatchTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}*/

class StopwatchTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minuteStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minuteStr:$secondsStr:$hundredsStr";
  }
}
