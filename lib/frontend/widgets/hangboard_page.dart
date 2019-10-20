/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/frontend/widgets/exercise_tile.dart';
import 'package:crux/frontend/widgets/workout_timer.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class HangboardPage extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exerciseParameters;
  final VoidCallback nextPageCallback;
  final DocumentReference documentReference;
  final String workoutTitle;

  HangboardPage(
      {this.index,
      this.exerciseParameters,
      this.nextPageCallback,
      this.documentReference,
        this.workoutTitle});

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState extends State<HangboardPage> {
  PageStorageKey timerKey;
  bool _isEditing;

  String _exerciseTitle;
  double _depth;
  String _depthMeasurementSystem;
  String _fingerConfiguration;
  String _hold;
  int _hangsPerSet;
  int _numberOfSets;
  int _resistance;
  String _resistanceMeasurementSystem;
  int _timeBetweenSets;
  int _timeOff;
  int _timeOn;
  int _originalNumberOfSets;
  int _originalNumberOfHangs;
  int _numberOfHands;

  bool _exerciseFinished;
  bool _didFinishSet;
  WorkoutTimer _workoutTimer;

  @override
  void initState() {
    super.initState();
    _exerciseFinished = false;
    _isEditing = false;
    _didFinishSet = false;
    _originalNumberOfSets = widget.exerciseParameters['numberOfSets'];
    _originalNumberOfHangs = widget.exerciseParameters['hangsPerSet'];
    getParams(widget.exerciseParameters);
    _exerciseTitle = StringFormatUtils.formatDepthAndHold(
        _depth, _depthMeasurementSystem, _fingerConfiguration, _hold);
    _workoutTimer = WorkoutTimer(
      id: '${widget.workoutTitle} $_exerciseTitle',
      time: _timeOn,
      switchForward: false,
      switchTimer: false,
      notifyParentReverseComplete: notifyParentReverseComplete,
      notifyParentForwardComplete: notifyParentForwardComplete,
//      preferencesClearedFlag: widget.preferencesClearedFlag,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          titleTile(),
          workoutTimerTile(),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                hangsAndResistanceTile(),
                setsTile(),
              ],
            ),
          ),
          */
/*Stack(
            children: <Widget>[
              _exerciseFinished
                  ? Banner(
                      location: BannerLocation.topStart,
                      message: 'Finished!',
                    )
                  : null,
            ].where(notNull).toList(),
          ),*/ /*

          notesTile(),
        ],
      ),
    );
  }

//  bool notNull(Object o) => o != null;

  Widget titleTile() {
    return ExerciseTile(
      tileColor: Theme
          .of(context)
          .accentColor,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
          child: Column(
            children: <Widget>[
              Text(
                '$_numberOfHands Handed $_exerciseTitle',
                softWrap: true,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget hangsAndResistanceTile() {
    return Container(
      constraints:
      BoxConstraints(maxWidth: MediaQuery
          .of(context)
          .size
          .width / 2.0),
      child: ExerciseTile(
        edgeInsets: const EdgeInsets.only(left: 8.0, top: 8.0, right: 4.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _hangsPerSet < _originalNumberOfHangs
                      ? IconButton(
                      icon: Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        if(_hangsPerSet != _originalNumberOfHangs) {
                          setState(() {
                            _hangsPerSet++;
                          });
                        }
                      })
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                  Text(
                    '$_hangsPerSet',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  _hangsPerSet > 0
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if(_hangsPerSet != 0) {
                        setState(() {
                          _hangsPerSet--;
                        });
                      }
                    },
                  )
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      StringFormatUtils.formatHangsAndResistance(_hangsPerSet,
                          _resistance, _resistanceMeasurementSystem),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setsTile() {
    return Container(
      constraints:
      BoxConstraints(maxWidth: MediaQuery
          .of(context)
          .size
          .width / 2.0),
      child: ExerciseTile(
        edgeInsets: const EdgeInsets.only(left: 4.0, top: 8.0, right: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _numberOfSets < _originalNumberOfSets
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    onPressed: () {
                      if(_numberOfSets != _originalNumberOfSets) {
                        setState(() {
                          _numberOfSets++;
                        });
                      }
                    },
                  )
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                  Text(
                    '$_numberOfSets',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  _numberOfSets > 0
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if(_numberOfSets != 0) {
                        setState(() {
                          _numberOfSets--;
                        });
                      }
                    },
                  )
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _numberOfSets == 1 ? ' set' : ' sets',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget workoutTimerTile() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery
            .of(context)
            .size
            .width / 1.2,
      ),
      child: ExerciseTile(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0.0,
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery
                          .of(context)
                          .size
                          .width / 1.4,
                    ),
                    child: _workoutTimer,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        switchTimer(false, _timeOn);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        IconData(
                          0xe5d5,
                          fontFamily: 'MaterialIcons',
                          matchTextDirection: true,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      onPressed: () {
                        switchTimer(true, _timeOff);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget notesTile() {
    return ExerciseTile(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Notes: ',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            TextField(),
          ],
        ),
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

  void getParams(Map<String, dynamic> exerciseParameters) {
    _depth = getDoubleVal(exerciseParameters, 'depth');
    _depthMeasurementSystem =
        getStringVal(exerciseParameters, 'depthMeasurementSystem');
    _fingerConfiguration =
        getStringVal(exerciseParameters, 'fingerConfiguration');
    _hold = getStringVal(exerciseParameters, 'hold');
    _hangsPerSet = getIntVal(exerciseParameters, 'hangsPerSet');
    _numberOfSets = getIntVal(exerciseParameters, 'numberOfSets');
    _resistance = getIntVal(exerciseParameters, 'resistance');
    _resistanceMeasurementSystem =
        getStringVal(exerciseParameters, 'resistanceMeasurementSystem');
    _timeBetweenSets = getIntVal(exerciseParameters, 'timeBetweenSets');
    _timeOn = getIntVal(exerciseParameters, 'timeOn');
    _timeOff = getIntVal(exerciseParameters, 'timeOff');
    _numberOfHands = getIntVal(exerciseParameters, 'numberOfHands');
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

  double getDoubleVal(
      Map<String, dynamic> exerciseParameters, String fieldName) {
    try {
      var doubleVal = exerciseParameters[fieldName];
      if (doubleVal is double) return doubleVal;
    } on Exception catch (e) {
      print('Unable to find $fieldName: $e');
    }
    return 0.0;
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
*/
