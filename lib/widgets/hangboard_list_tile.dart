import 'package:crux/widgets/timer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardListTile extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exerciseParameters;

  HangboardListTile({this.index, this.exerciseParameters});

  @override
  State<HangboardListTile> createState() => _HangboardListTileState();
}

class _HangboardListTileState extends State<HangboardListTile> {
  //todo: wrap these in data class?
  String _depth = '';
  String _grip = '';
  int _repTime = 0;
  String _resistance = '';
  int _restTime = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: Colors.amber,
      elevation: 3.0,
      margin: EdgeInsets.all(3.0),
      //todo:is this necessary? look into  clipbehavior
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          key: PageStorageKey('${widget.index}'),
          //leading: const Icon(Icons.timer),
          /*leading: Text(
            'Rep ${widget.index + 1}',
            style: TextStyle(fontSize: 15.0),
          ),*/
          title: Text(
            '${_depth}mm $_grip',
            style: TextStyle(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '$_resistance pounds',
            style: TextStyle(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          /*leading: TimerText(
            timer: timer,
          )*/
          trailing: ConstrainedBox(
            key: PageStorageKey('Timer${widget.index}'),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 6.0),
            child: TimerTextAnimator(
              repTime: _repTime,
              restTime: _restTime,
            ),
          ),
          /*onTap: tapStartStop,
          onLongPress: longPressReset,*/
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getParams(widget.exerciseParameters);
  }

  void getParams(Map<String, dynamic> exerciseParameters) {
    getDepth(exerciseParameters);
    getGrip(exerciseParameters);
    getRepTime(exerciseParameters);
    getRestTime(exerciseParameters);
    getResistance(exerciseParameters);
  }

  void getDepth(Map<String, dynamic> exerciseParameters) {
    try {
      var depth = exerciseParameters['depth'];
      if(depth is int) {
        setState(() {
          _depth = depth.toString();
        });
      }
    } on Exception catch(e) {
      print('Unable to find depth: $e');
    }
  }

  //TODO: required
  void getGrip(Map<String, dynamic> exerciseParameters) {
    try {var grip = exerciseParameters['grip'];
    if (grip is String) {
      setState(() {
        _grip = grip;
      });
    }
    } on Exception catch(e) {
      print('Unable to find grip: $e');
    }
  }

  //TODO: required
  void getRepTime(Map<String, dynamic> exerciseParameters) {
    try {
      var repTime =
      exerciseParameters['repTime'];
      if (repTime is int) {
        setState(() {
          _repTime = repTime;
        });
      }
    } on Exception catch(e) {
      print('Unable to find repTime: $e');
    }
  }

  void getRestTime(Map<String, dynamic> exerciseParameters) {
    try {
      var restTime =
      exerciseParameters['restTime'];
      if (restTime is int) {
        setState(() {
          _restTime = restTime;
        });
      }
    } on Exception catch(e) {
      print('Unable to find restTime: $e');
    }
  }

  void getResistance(Map<String, dynamic> exerciseParameters) {
    try {
      var resistance =
      exerciseParameters['resistance'];
      if(resistance is int) {
        setState(() {
          _resistance = resistance.toString();
        });
      }
    } on Exception catch(e) {
      print('Unable to find resistance: $e');
    }
  }

  VoidCallback repFinished() {
    //Todo: reset timer with rest param, create new callback for that new timer
  }
}
