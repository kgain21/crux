import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/bottom_nav_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/hangboard_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

class RepListScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final Firestore firestore;

  //TODO: going to have to make sure this syncs offline***
  //TODO: can i access firestore statically? Do i need to pass it as var to different screens?

  RepListScreen({Key key, this.title, this.auth, this.firestore})
      : super(key: key);

  @override
  _RepListScreenState createState() => new _RepListScreenState();
}

class _RepListScreenState extends State<RepListScreen> {
  Stopwatch stopwatch = new Stopwatch();
  CollectionReference maxHangs;
  DocumentSnapshot snapshot;

  //AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: SharedAppBar.sharedAppBar(
        widget.title,
        widget.auth,
        this.context,
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            //TODO: look at separated listview
            Container(
              child: new StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .document('workouts/hangboard')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Row(
                        children: <Widget>[
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      );
                    default:
                      return Flexible(
                        child: ListView.builder(
                          itemCount: snapshot.data['max_hangs'].length,
                          itemBuilder: (context, index) {
                            return HangboardListTile(
                              index: index,
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SharedBottomNavBar.bottomNavBar(),
    );
  }

  Widget buildFloatingButton(
      String text, VoidCallback callback, String heroTag) {
    TextStyle textStyle = new TextStyle(
      fontSize: 14.0,
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
      fontSize: 60.0,
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

class RepListTextFormatter {
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
