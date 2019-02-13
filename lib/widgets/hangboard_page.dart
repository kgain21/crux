import 'package:crux/widgets/workout_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardPage extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exerciseParameters;

  HangboardPage({this.index, this.exerciseParameters});

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState
    extends State<HangboardPage> /*with AutomaticKeepAliveClientMixin*/ {
  PageStorageKey timerKey;

  //todo: wrap these in data class?
  int _depth;
  int _resistance;
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  String _grip;
  int _hangs;
  int _repTime;
  int _restTime;
  bool _didFinishSet;
  WorkoutTimer _workoutTimer;

  @override
  void initState() {
    super.initState();
    _didFinishSet = false;
    getParams(widget.exerciseParameters);
    _workoutTimer = WorkoutTimer(
      id: widget.index.toString(),
      time: _repTime,
      switchForward: false,
      switchTimer: false,
      //TODO: is there a better way to do this?
      notifyParentReverseComplete: notifyParentReverseComplete,
      notifyParentForwardComplete: notifyParentForwardComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 20.0,
          ),
          right: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 20.0,
          ),
          top: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 20.0,
          ),
          bottom: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 60.0,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black54, blurRadius: 6.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          children: <Widget>[
            holdText(),
            hangsAndResistanceCheckbox(),
            workoutTimerContainer(),
            switchButtonRow(),
          ],
        ),
      ),
    );
  }

  Widget holdText() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 2.0, offset: Offset(0.0, 2.0)),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0)),
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
            child: Text(
              formatDepthAndGrip(_depth, _depthMeasurementSystem, _grip),
              style: TextStyle(
                fontSize: 26.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hangsAndResistanceCheckbox() {
    return new CheckboxListTile(
      value: _didFinishSet,
      onChanged: (value) {
        setState(() {
          _didFinishSet = value;
        });
      },
      title: Text(
        formatHangsAndResistance(
            _hangs, _resistance, _resistanceMeasurementSystem),
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget workoutTimerContainer() {
    return new Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.75),
        child: _workoutTimer,
      ),
    );
  }

  Widget switchButtonRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: new InputChip(
              label: Text('Exercise'),
              onPressed: () {
                switchTimer(false, _repTime);
              },
            ),
          ),
          new InputChip(
            label: Text('   Rest   '),
            onPressed: () {
              switchTimer(true, _restTime);
            },
          ),
        ],
      ),
    );
  }

  /// Timer should only know about rep OR rest, not both
  void switchTimer(bool resetForward, int time) {
    setState(() {
      _workoutTimer = WorkoutTimer(
        notifyParentReverseComplete: notifyParentReverseComplete,
        notifyParentForwardComplete: notifyParentForwardComplete,
        id: widget.index.toString(),
        switchTimer: true,
        switchForward: resetForward,
        time: time,
      );
    });
  }

  void notifyParentReverseComplete() {
    setState(() {
      _workoutTimer = WorkoutTimer(
        notifyParentReverseComplete: notifyParentReverseComplete,
        notifyParentForwardComplete: notifyParentForwardComplete,
        id: widget.index.toString(),
        switchTimer: true,
        switchForward: true,
        time: _restTime,
      );
      _hangs = _hangs > 0 ? (_hangs - 1) : 0;
      // return AlertDialog(content: Text('Set Finished!'),);
    });
    //TODO: left off here 1/31
    //todo: some kind of overlay telling you you're done
  }

  void notifyParentForwardComplete() {
    setState(() {
      _workoutTimer = WorkoutTimer(
        notifyParentReverseComplete: notifyParentReverseComplete,
        notifyParentForwardComplete: notifyParentForwardComplete,
        id: widget.index.toString(),
        switchTimer: true,
        switchForward: false,
        time: _repTime,
      );
    });
  }

  String formatDepthAndGrip(
      int depth, String depthMeasurementSystem, String grip) {
    if (depth == null || depth == 0) {
      return grip;
    } else {
      return '$depth$depthMeasurementSystem $grip';
    }
  }

  formatHangsAndResistance(
      int hangs, int resistance, String resistanceMeasurementSystem) {
    if (hangs == null || hangs == 1) {
      if (resistance == null || resistance == 0) {
        return '$hangs hang at bodyweight';
      } else {
        return '$hangs hang with $resistance$resistanceMeasurementSystem';
      }
    } else {
      if (resistance == null || resistance == 0) {
        return '$hangs hangs at bodyweight';
      } else {
        return '$hangs hangs with $resistance$resistanceMeasurementSystem';
      }
    }
  }

//TODO: should this be separated from the widget in a dao?
//TODO: call the getParams method on expand? might be slow
  void getParams(Map<String, dynamic> exerciseParameters) {
    setState(() {
      _depth = getDepth(exerciseParameters);
      _depthMeasurementSystem = getDepthMeasurementSystem(exerciseParameters);
      _resistance = getResistance(exerciseParameters);
      _resistanceMeasurementSystem =
          getResistanceMeasurementSystem(exerciseParameters);
      _grip = getGrip(exerciseParameters);
      _repTime = getRepTime(exerciseParameters);
      _restTime = getRestTime(exerciseParameters);
      _hangs = getHangs(exerciseParameters);
    });
  }

  int getDepth(Map<String, dynamic> exerciseParameters) {
    try {
      var depth = exerciseParameters['depth'];
      if (depth is int) return depth;
    } on Exception catch (e) {
      print('Unable to find depth: $e');
    }
    return 0;
  }

  String getDepthMeasurementSystem(Map<String, dynamic> exerciseParameters) {
    try {
      var depthMeasurementSystem = exerciseParameters['depthMeasurementSystem'];
      if (depthMeasurementSystem is String) {
        return depthMeasurementSystem;
      }
    } on Exception catch (e) {
      print('Unable to find depthMeasurementSystem: $e');
    }
    return '';
  }

  int getResistance(Map<String, dynamic> exerciseParameters) {
    try {
      var resistance = exerciseParameters['resistance'];
      if (resistance is int) {
        return resistance;
      }
    } on Exception catch (e) {
      print('Unable to find resistance: $e');
    }
    return 0;
  }

  String getResistanceMeasurementSystem(
      Map<String, dynamic> exerciseParameters) {
    try {
      var resistanceMeasurementSystem =
          exerciseParameters['resistanceMeasurementSystem'];
      if (resistanceMeasurementSystem is String) {
        return resistanceMeasurementSystem;
      }
    } on Exception catch (e) {
      print('Unable to find resistanceMeasurementSystem: $e');
    }
    return '';
  }

//TODO: required
  String getGrip(Map<String, dynamic> exerciseParameters) {
    try {
      var grip = exerciseParameters['grip'];
      if (grip is String) {
        return grip;
      }
    } on Exception catch (e) {
      print('Unable to find grip: $e');
    }
    return '';
  }

//TODO: required
  int getHangs(Map<String, dynamic> exerciseParameters) {
    try {
      var hangs = exerciseParameters['hangs'];
      if (hangs is int) {
        return hangs;
      }
    } on Exception catch (e) {
      print('Unable to find hangs: $e');
    }
    return 0;
  }

//TODO: required
  int getRepTime(Map<String, dynamic> exerciseParameters) {
    try {
      var repTime = exerciseParameters['repTime'];
      if (repTime is int) {
        return repTime;
      }
    } on Exception catch (e) {
      print('Unable to find repTime: $e');
    }
    return 0;
  }

  int getRestTime(Map<String, dynamic> exerciseParameters) {
    try {
      var restTime = exerciseParameters['restTime'];
      if (restTime is int) {
        return restTime;
      }
    } on Exception catch (e) {
      print('Unable to find restTime: $e');
    }
    return 0;
  }

/*
  @override
  void updateKeepAlive() {
    // TODO: implement updateKeepAlive
  }
*/

/*@override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;*/
}
