import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/widgets/workout_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardPage extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exerciseParameters;
  final VoidCallback nextPageCallback;
  final DocumentReference documentReference;

  HangboardPage(
      {this.index,
      this.exerciseParameters,
      this.nextPageCallback,
      this.documentReference});

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState extends State<HangboardPage> {
  PageStorageKey timerKey;
  bool _isEditing;

  String _exerciseTitle;
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

  bool _exerciseFinished;
  bool _didFinishSet;
  WorkoutTimer _workoutTimer;

  @override
  void initState() {
    super.initState();
    _exerciseFinished = false;
    _isEditing = false;
    _didFinishSet = false;
    getParams(widget.exerciseParameters);
    _exerciseTitle = formatDepthAndGrip(
        _depth, _depthMeasurementSystem, _fingerConfiguration, _grip);
    _workoutTimer = WorkoutTimer(
      id: _exerciseTitle,
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
      decoration: pageBorderDecoration(),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            //border: Border.all(color: Colors.black, width: 2.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 6.0,
                spreadRadius: 1.0,
                offset: Offset(0.0, 4.0),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Theme.of(context).canvasColor,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              //constraints.
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      titleBox(),
                      _exerciseFinished
                          ? Banner(
                              location: BannerLocation.topStart,
                              message: 'Finished!',
                            )
                          : null,
                    ].where(notNull).toList(),
                  ),
                  hangsAndResistanceRow(),
                  workoutTimerContainer(),
                  switchButtonRow(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool notNull(Object o) => o != null;

  BoxDecoration pageBorderDecoration() {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: Theme.of(context).primaryColor /*Dark*/,
          width: 15.0,
        ),
        right: BorderSide(
          color: Theme.of(context).primaryColor /*Dark*/,
          width: 15.0,
        ),
        top: BorderSide(
          color: Theme.of(context).primaryColor /*Dark*/,
          width: 15.0,
        ),
        bottom: BorderSide(
          color: Theme.of(context).primaryColor /*Dark*/,
          width: 60.0,
        ),
      ),
    );
  }

  Widget titleBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(8.0),
        ),
        /* boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6.0,
            offset: Offset(0.0, 2.0),
          ),
        ],*/
        color: Theme.of(context).accentColor,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
                  child: Text(
                    _exerciseTitle,
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),
          /*Row(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Test Row',
                    style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }

  Widget hangsAndResistanceRow() {
    return new ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            '$_hangsPerSet',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            formatHangsAndResistance(
                _hangsPerSet, _resistance, _resistanceMeasurementSystem),
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '|',
            style: TextStyle(fontSize: 26.0),
          ),
          Text(
            '$_numberOfSets',
            style: TextStyle(fontSize: 30.0),
          ),
          Text(
            ' sets',
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
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.5),
        child: _workoutTimer,
      ),
    );
  }

  Widget switchButtonRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            //elevation: 4.0,
            icon: Icon(Icons.skip_previous), //Text('Exercise'),
            onPressed: () {
              null;
            },
          ),
          IconButton(
            //elevation: 4.0,
            icon: Icon(Icons.refresh), //Text('Exercise'),
            onPressed: () {
              switchTimer(false, _timeOn);
            },
          ),
          IconButton(
            //elevation: 4.0,
            icon: Icon(
              IconData(0xe5d5,
                  fontFamily: 'MaterialIcons', matchTextDirection: true),
              textDirection: TextDirection.rtl,
            ), //Text('Rest'),
            onPressed: () {
              switchTimer(true, _timeOff);
            },
          ),
          IconButton(
            //elevation: 4.0,
            icon: Icon(Icons.skip_next),
            onPressed: () {
              null;
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
        id: _exerciseTitle,
        switchTimer: true,
        switchForward: resetForward,
        startTimer: false,
        time: time,
      );
    });
  }

  void notifyParentReverseComplete() {
    setState(() {
      _hangsPerSet = _hangsPerSet > 0 ? (_hangsPerSet - 1) : 0;

      /// Start time between sets and provide callback that decrements number of
      /// sets as well as resets number of hangs
      if (_hangsPerSet == 0) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Set Complete!',
                  style: TextStyle(
                      fontSize: 25.0, color: Theme.of(context).accentColor),
                ),
              ],
            ),
          ),
        );
        _workoutTimer = WorkoutTimer(
          notifyParentReverseComplete: notifyParentReverseComplete,
          notifyParentForwardComplete:
              notifyParentForwardTimeBetweenSetsComplete,
          id: _exerciseTitle,
          switchTimer: true,
          switchForward: true,
          startTimer: true,
          time: _timeBetweenSets,
        );
      } else {
        _workoutTimer = WorkoutTimer(
          notifyParentReverseComplete: notifyParentReverseComplete,
          notifyParentForwardComplete: notifyParentForwardComplete,
          id: _exerciseTitle,
          switchTimer: true,
          switchForward: true,
          startTimer: true,
          time: _timeOff,
        );
      }
      // return AlertDialog(content: Text('Set Finished!'),);
      // start timebetweensets if applicable
    });
  }

  void notifyParentForwardComplete() {
    setState(() {
      _workoutTimer = WorkoutTimer(
        notifyParentReverseComplete: notifyParentReverseComplete,
        notifyParentForwardComplete: notifyParentForwardComplete,
        id: _exerciseTitle,
        switchTimer: true,
        switchForward: false,
        startTimer: true,
        time: _timeOn,
      );
    });
  }

  void notifyParentForwardTimeBetweenSetsComplete() {
    setState(() {
      _numberOfSets = _numberOfSets > 0 ? _numberOfSets - 1 : 0;

      if (_numberOfSets == 0) {
        _exerciseFinished = true;
        _workoutTimer = WorkoutTimer(
          notifyParentReverseComplete: null,
          notifyParentForwardComplete: null,
          id: _exerciseTitle,
          switchTimer: true,
          switchForward: false,
          startTimer: false,
          time: 0,
        );
        //TODO: still want to add banner
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(days: 1),
          content: Row(),
          action: SnackBarAction(
            label: 'Next Exercise',
            onPressed: widget.nextPageCallback,
          ),
        ));
      } else {
        _hangsPerSet = widget.exerciseParameters['hangsPerSet'];

        _workoutTimer = WorkoutTimer(
          notifyParentReverseComplete: notifyParentReverseComplete,
          notifyParentForwardComplete: notifyParentForwardComplete,
          id: _exerciseTitle,
          switchTimer: true,
          switchForward: false,
          startTimer: true,
          time: _timeOn,
        );
      }
    });
  }

  String formatDepthAndGrip(/*int numberOfHands,*/ int depth,
      String depthMeasurementSystem, String fingerConfiguration, String grip) {
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
        return ' hang at bodyweight';
      } else {
        return ' hang with $resistance$resistanceMeasurementSystem';
      }
    } else {
      if (resistance == null || resistance == 0) {
        return ' hangs at bodyweight';
      } else {
        return ' hangs with $resistance$resistanceMeasurementSystem';
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
