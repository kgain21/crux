import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/bottom_nav_bar.dart';
import 'package:crux/utils/base_auth.dart';
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
  DocumentReference documentReference;
  String _depth = '';
  String _grip = '';

  @override
  void initState() {
    /*maxHangs = widget.firestore.collection('workouts/hangboard/max_hangs');
    documentReference = widget.firestore.document('workouts/hangboard');*/
  }

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
            /*new ListTile(
              leading: const Icon(Icons.timer),
              title: const Text('Rep 1'),
              trailing: const Text('22mm \nHalf-Crimp'),
              subtitle: RepListWidgetText(
                stopwatch: stopwatch,
              ),
              onTap: rightButtonPressed,
              onLongPress: leftButtonPressed,
            ),*/
            //TODO: look at separated listview
            Container(
              child: new StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .document('workouts/hangboard')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading data... Please wait.');
                  } else {
                    return Flexible(
                      child: ListView.builder(
                        itemCount: snapshot.data['max_hangs'].length,
                        itemBuilder: (context, index) {
                          /*DocumentSnapshot set =
                              snapshot.data['max_hangs'][index]['set1'];*/
                          return ListTile(
                            leading: const Icon(Icons.timer),
                            title: Text('Rep 1'),
                            trailing: Text(_depth +
                                '\n' +
                                _grip /*'$set["depth"] \n$set["grip"]'*/),
                            subtitle: RepListWidgetText(
                              stopwatch: stopwatch,
                            ),
                            onTap: rightButtonPressed,
                            onLongPress: leftButtonPressed,
                          );
                        },
                      ),
                    );
                    //return Text(snapshot.data['max_hangs'][0]['set1']['grip']);
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

  Future<void> getParams() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('workouts')
        .document('hangboard')
        .get();
    var depth = snapshot['max_hangs'][0]['set1']['depth'];
    var grip = snapshot['max_hangs'][0]['set1']['grip'];
    if (depth is int && grip is String) {
      setState(() {
        _depth = depth.toString();
        _grip = grip;
      });
    } else {
      throw new Exception('Unable to find depth');
    }
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
