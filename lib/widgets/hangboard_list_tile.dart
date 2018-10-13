import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/rep_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardListTile extends StatefulWidget {
  final int index;

  HangboardListTile({this.index});

  @override
  State<HangboardListTile> createState() => _HangboardListTileState();
}

class _HangboardListTileState extends State<HangboardListTile> {
  Stopwatch stopwatch;
  Timer timer;
  String _depth = '';
  String _grip = '';

  @override
  void initState() {
    super.initState();

    getParams();
    stopwatch = new Stopwatch();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: const Icon(Icons.timer),
      leading: Text('Rep ${widget.index + 1}'),
      title: Text(_depth + 'mm ' + _grip),
      subtitle: RepListWidgetText(
        stopwatch: stopwatch,
      ),
      onTap: tapStartStop,
      onLongPress: longPressReset,
    );
  }

  void longPressReset() {
    setState(() {
      if (stopwatch.isRunning) {
        print('${stopwatch.elapsedMilliseconds}');
      } else
        stopwatch.reset();
    });
  }

  void tapStartStop() {
    setState(() {
      if (stopwatch.isRunning)
        stopwatch.stop();
      else
        stopwatch.start();
    });
  }

  Future<void> getParams() async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection('workouts')
        .document('hangboard')
        .get();
    getDepth(snapshot);
    getGrip(snapshot);
  }

  void getDepth(DocumentSnapshot snapshot) {
    var depth = snapshot['max_hangs'][widget.index]['set1']['depth'];
    if (depth is int) {
      setState(() {
        _depth = depth.toString();
      });
    } else {
      throw new Exception('Unable to find params');
    }
  }

  void getGrip(DocumentSnapshot snapshot) {
    var grip = snapshot['max_hangs'][widget.index]['set1']['grip'];
    if (grip is String) {
      setState(() {
        _grip = grip;
      });
    } else {
      throw new Exception('Unable to find params');
    }
  }
}
