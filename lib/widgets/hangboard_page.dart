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

class _HangboardPageState extends State<HangboardPage> {
  PageStorageKey timerKey;

  int _depth;
  String _depthMeasurementSystem;
  String _fingerConfiguration;
  String _grip;
  int _hangsPerSet;
  int _numberOfSets;
  int _resistance;
  String _resistanceMeasurementSystem;
  int _timeBetweenSets;
  int _timeOff;
  int _timeOn;

  bool _didFinishSet;
  WorkoutTimer _workoutTimer;

  @override
  void initState() {
    super.initState();
    _didFinishSet = false;
    getParams(widget.exerciseParameters);
    _workoutTimer = WorkoutTimer(
      id: widget.index.toString(),
      time: _timeOn,
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
            width: 15.0,
          ),
          right: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 15.0,
          ),
          top: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 15.0,
          ),
          bottom: BorderSide(
            color: Theme.of(context).primaryColorDark,
            width: 60.0,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.black, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6.0,
              offset: Offset(0.0, 2.0),
              /*spreadRadius: 2.0,*/
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).canvasColor,
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceE,
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(8.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
        color: Theme.of(context).accentColor,
      ),
      child: Row(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
              child: Text(
                formatDepthAndGrip(_depth, _depthMeasurementSystem,
                    _fingerConfiguration, _grip),
                style: TextStyle(
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget hangsAndResistanceCheckbox() {
    return new ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            formatHangsAndResistance(
                _hangsPerSet, _resistance, _resistanceMeasurementSystem),
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '|',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '$_numberOfSets sets',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
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
            child: new RaisedButton(
              elevation: 4.0,
              child: Text('Exercise'),
              onPressed: () {
                switchTimer(false, _timeOn);
              },
            ),
          ),
          new RaisedButton(
            elevation: 4.0,
            // label: Text('   Rest   '),
            child: Text('Rest'),

            onPressed: () {
              switchTimer(true, _timeOff);
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
        time: _timeOff,
      );
      _hangsPerSet = _hangsPerSet > 0 ? (_hangsPerSet - 1) : 0;
      // return AlertDialog(content: Text('Set Finished!'),);
      // start timebetweensets if applicable
    });
  }

  void notifyParentForwardComplete() {
    setState(() {
      _workoutTimer = WorkoutTimer(
        notifyParentReverseComplete: notifyParentReverseComplete,
        notifyParentForwardComplete: notifyParentForwardComplete,
        id: widget.index.toString(),
        switchTimer: true,
        switchForward: false,
        time: _timeOn,
      );
    });
  }

  String formatDepthAndGrip(int depth, String depthMeasurementSystem,
      String fingerConfiguration, String grip) {
    if (depth == null || depth == 0) {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return grip;
      } else {
        return '$fingerConfiguration $grip';
      }
    } else {
      return '$depth$depthMeasurementSystem $fingerConfiguration $grip';
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
  void getParams(Map<String, dynamic> exerciseParameters) {
    _depth = getIntVal(exerciseParameters, 'depth');
    _depthMeasurementSystem =
        getStringVal(exerciseParameters, 'depthMeasurementSystem');
    _fingerConfiguration =
        getStringVal(exerciseParameters, 'fingerConfiguration');
    _grip = getStringVal(exerciseParameters, 'grip');
    _hangsPerSet = getIntVal(exerciseParameters, 'hangsPerSet');
    _numberOfSets = getIntVal(exerciseParameters, 'numberOfSets');
    _resistance = getIntVal(exerciseParameters, 'resistance');
    _resistanceMeasurementSystem =
        getStringVal(exerciseParameters, 'resistanceMeasurementSystem');
    _timeBetweenSets = getIntVal(exerciseParameters, 'timeBetweenSets');
    _timeOn = getIntVal(exerciseParameters, 'timeOn');
    _timeOff = getIntVal(exerciseParameters, 'timeOff');
  }

  int getIntVal(Map<String, dynamic> exerciseParameters, String fieldName) {
    try {
      var intVal = exerciseParameters[fieldName];
      if (intVal is int) return intVal;
    } on Exception catch (e) {
      print('Unable to find $fieldName: $e');
    }
    return 0;
  }

  String getStringVal(
      Map<String, dynamic> exerciseParameters, String fieldName) {
    try {
      var stringVal = exerciseParameters[fieldName];
      if (stringVal is String) {
        return stringVal;
      }
    } on Exception catch (e) {
      print('Unable to find $fieldName: $e');
    }
    return '';
  }
}
