import 'dart:async';

import 'package:crux/shared_layouts/appbar.dart';
import 'package:crux/shared_layouts/bottom_nav_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class RepListScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;

  RepListScreen({Key key, this.title, this.auth}) : super(key: key);

  @override
  _RepListScreenState createState() => new _RepListScreenState();
}

class _RepListScreenState extends State<RepListScreen> {
  Stopwatch stopwatch = new Stopwatch();

  bool isLapPressed = false;

  void _signOut() {
    try {
      widget.auth.signOut(this.context);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: SharedAppBar.sharedAppbar(
        widget.title,
        _signOut,
        this.context,
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new RepListWidgetText(
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
            new ListTile(
              leading: const Icon(Icons.ac_unit),
              title: const Text('AC UNIT'),
              subtitle: const Text('this is a test'),
              onTap: rightButtonPressed,
            ),
            new SwitchListTile(
              title: const Text('Lights'),
              value: isLapPressed,
              onChanged: (bool value) {
                setState(() {
                  isLapPressed = value;
                });
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
            new CheckboxListTile(
              title: const Text('Animate Slowly'),
              value: timeDilation != 1.0,
              onChanged: (bool value) {
                setState(() {
                  timeDilation = value ? 20.0 : 1.0;
                });
              },
              secondary: const Icon(Icons.hourglass_empty),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar.bottomNavBar(),
    );
  }

  /*Widget createRepListText(bool isLapPressed) {
    if(isLapPressed) {
      isLapPressed = false;
    }
    return stopwatchText;
  }*/

  void leftButtonPressed() {
    setState(() {
      if (stopwatch.isRunning) {
        print('${stopwatch.elapsedMilliseconds}');
/*
        isLapPressed = true;
*/
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

/*_RepListScreenState({this.auth});*/
}

class RepListWidgetText extends StatefulWidget {
  final Stopwatch stopwatch;

  @override
  State<RepListWidgetText> createState() =>
      new _RepListWidgetTextState(stopwatch);

  RepListWidgetText({this.stopwatch});
}

class _RepListWidgetTextState extends State<RepListWidgetText> {
  final Stopwatch stopwatch;
  Timer timer;

  _RepListWidgetTextState(this.stopwatch) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 72.0, //todo: just build another timerText -_-
      fontFamily: "Open Sans",
    );
    String formattedTime =
        RepListTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}

class RepListWidgetLapText extends StatefulWidget {
  final Stopwatch stopwatch;

  @override
  State<RepListWidgetLapText> createState() =>
      new _RepListWidgetLapTextState(stopwatch);

  RepListWidgetLapText({this.stopwatch});
}

class _RepListWidgetLapTextState extends State<RepListWidgetLapText> {
  final Stopwatch stopwatch;
  Timer timer;

  _RepListWidgetLapTextState(this.stopwatch) {
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
        RepListTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}
/*class RepListWidgetSubText extends StatefulWidget {
  final RepList stopwatch;

  @override
  State<RepListWidgetSubText> createState() =>
      new _RepListWidgetSubTextState(stopwatch);

  RepListWidgetSubText({this.stopwatch});
}

class _RepListWidgetSubTextState extends State<RepListWidgetSubText> {
  final RepList stopwatch;
  Timer timer;

  _RepListWidgetSubTextState(this.stopwatch) {
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
    RepListTextFormatter.format(stopwatch.elapsedMilliseconds);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}*/

class RepListTextFormatter {
  static String format(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minuteStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 60).toString().padLeft(2, '0');

    return "$minuteStr:$secondsStr:$hundredsStr";
  }
}
