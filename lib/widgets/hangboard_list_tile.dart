import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/widgets/timer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardListTile extends StatefulWidget {
  final int index;
  final DocumentSnapshot snapshot;

  HangboardListTile({this.index, this.snapshot});

  @override
  State<HangboardListTile> createState() => _HangboardListTileState();
}

class _HangboardListTileState extends State<HangboardListTile> {
  //todo: wrap these in data class?
  String _depth = '';
  String _grip = '';
  int _repTime = 0;
  String _weight = '';
  int _restTime = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(3.0),
      //todo:is this necessary? look into  clipbehavior
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
          //leading: const Icon(Icons.timer),
          leading: Text(
            'Rep ${widget.index + 1}',
            style: TextStyle(fontSize: 15.0),
          ),
          title: Text(
            '${_depth}mm $_grip',
            style: TextStyle(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '$_weight pounds',
            style: TextStyle(fontSize: 15.0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          /*leading: TimerText(
            timer: timer,
          )*/
          trailing: ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 5.0),
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
    getParams(widget.snapshot);
  }

  void getParams(DocumentSnapshot snapshot) {
    getDepth(snapshot);
    getGrip(snapshot);
    getRepTime(snapshot);
    getRestTime(snapshot);
    getWeight(snapshot);
  }

  void getDepth(DocumentSnapshot snapshot) {
    var depth = snapshot['max_hangs'][widget.index]['set1']['depth'];
    if (depth is int) {
      setState(() {
        _depth = depth.toString();
      });
    } else {
      throw new Exception('Unable to find depth');
    }
  }

  void getGrip(DocumentSnapshot snapshot) {
    var grip = snapshot['max_hangs'][widget.index]['set1']['grip'];
    if (grip is String) {
      setState(() {
        _grip = grip;
      });
    } else {
      throw new Exception('Unable to find grip');
    }
  }

  void getRepTime(DocumentSnapshot snapshot) {
    var repTime = snapshot['max_hangs'][widget.index]['set1']['repTime'];
    if (repTime is int) {
      setState(() {
        _repTime = repTime;
      });
    } else {
      throw new Exception('Unable to find repTime');
    }
  }

  void getRestTime(DocumentSnapshot snapshot) {
    var restTime = snapshot['max_hangs'][widget.index]['set1']['restTime'];
    if (restTime is int) {
      setState(() {
        _restTime = restTime;
      });
    } else {
      throw new Exception('Unable to find restTime');
    }
  }

  void getWeight(DocumentSnapshot snapshot) {
    var weight = snapshot['max_hangs'][widget.index]['set1']['weight'];
    if (weight is int) {
      setState(() {
        _weight = weight.toString();
      });
    } else {
      throw new Exception('Unable to find weight');
    }
  }

  VoidCallback repFinished() {
    //Todo: reset timer with rest param, create new callback for that new timer
  }
}
