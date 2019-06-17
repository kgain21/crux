import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_bloc.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:crux/presentation/widgets/circular_timer.dart';
import 'package:crux/presentation/widgets/exercise_tile.dart';
import 'package:crux/presentation/widgets/workout_timer.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardPage extends StatefulWidget {
  final int index;

//  final Map<String, dynamic> exerciseParameters;
  final VoidCallback nextPageCallback;
  final DocumentReference documentReference;
  final String workoutTitle;

  final HangboardExercise hangboardExercise;

  HangboardPage({
    this.index,
//    this.exerciseParameters,
    this.nextPageCallback,
    this.documentReference,
    this.workoutTitle,
    this.hangboardExercise,
  });

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState extends State<HangboardPage>
    with TickerProviderStateMixin {
//  PageStorageKey timerKey;
  bool _isEditing;

  AnimationController _repController;
  AnimationController _restController;
  AnimationController _timeBetweenSetsController;

//  String _exerciseTitle;

//  int _originalNumberOfSets;
//  int _originalNumberOfHangs;
//  CircularTimer _circularTimer;
  TimerBloc _timerBloc;
  HangboardExerciseBloc _hangboardExerciseBloc;

  @override
  void initState() {
//    _isEditing = false;
//    _originalNumberOfSets = widget.exerciseParameters['numberOfSets'];
//    _originalNumberOfHangs = widget.exerciseParameters['hangsPerSet'];
//    getParams(widget.exerciseParameters);

    /*_exerciseTitle = StringFormatUtils.formatDepthAndHold(
        _depth, _depthMeasurementSystem, _fingerConfiguration, _hold);*/
    _repController = AnimationController(
      vsync: this,
      value: 0.0,
      duration: Duration(seconds: widget.hangboardExercise.repDuration),
    );
    _restController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(seconds: widget.hangboardExercise.restDuration),
    );
    _timeBetweenSetsController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(seconds: widget.hangboardExercise.timeBetweenSets),
    );

//    _circularTimer = CircularTimer(

//      id: '${widget.workoutTitle} $_exerciseTitle',
//      time: _timeOn,
//      switchForward: false,
//      switchTimer: false,
//      notifyParentReverseComplete: notifyParentReverseComplete,
//      notifyParentForwardComplete: notifyParentForwardComplete,
//      preferencesClearedFlag: widget.preferencesClearedFlag,
//        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HangboardExerciseBloc hangboardExerciseBloc =
        BlocProvider.of<HangboardExerciseBloc>(context);

    final TimerBloc timerBloc =
        TimerBloc(hangboardExerciseBloc: hangboardExerciseBloc);

    return BlocBuilder(
        bloc: _hangboardExerciseBloc,
        builder: (BuildContext context, HangboardExerciseState state) {
          if (state is HangboardExerciseLoading) {
            return Container();
          } else if (state is HangboardExerciseLoaded) {
            return BlocProvider(
              bloc: _timerBloc,
              child: Container(
                child: ListView(
                  children: <Widget>[
                    titleTile(state),
                    workoutTimerTile(state, timerBloc),
                    IntrinsicHeight(
                      child: Row(
                        children: <Widget>[
                          hangsAndResistanceTile(state),
                          setsTile(state),
                        ],
                      ),
                    ),
                    notesTile(state),
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget titleTile(HangboardExerciseLoaded state) {
    return ExerciseTile(
      tileColor: Theme.of(context).accentColor,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0.0, 12.0),
          child: Column(
            children: <Widget>[
              Text(
                '${state.hangboardExercise.numberOfHands} Handed ${state.hangboardExercise.exerciseTitle}',
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

  Widget workoutTimerTile(HangboardExerciseLoaded state, TimerBloc timerBloc) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.width / 1.2,
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
                      maxHeight: MediaQuery.of(context).size.width / 1.4,
                    ),
                    child: CircularTimer(),
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
                        //todo: dispatch here?
                        //todo: work on this event name
                        _hangboardExerciseBloc.dispatch(ResetTimerToRep());
                        switchTimer(false, state.hangboardExercise.repDuration);
//                        switchTimer(false, _timeOn);
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
                        //todo: dispatch here?
                        _hangboardExerciseBloc.dispatch(ResetTimerToRest());
                        switchTimer(true, state.hangboardExercise.restDuration);
//                        switchTimer(true, _timeOff);
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

  Widget hangsAndResistanceTile(HangboardExerciseLoaded state) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.0),
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
                            if (_hangsPerSet != _originalNumberOfHangs) {
                              setState(() {
                                _hangsPerSet++;
                              });
                              //TODO: stop timer
                            }
                          })
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_up,
                            color: Theme.of(context).primaryColorLight,
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
                            if (_hangsPerSet != 0) {
                              setState(() {
                                _hangsPerSet--;
                              });
                              //TODO: stop timer
                            }
                          },
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColorLight,
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

  Widget setsTile(HangboardExerciseLoaded state) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2.0),
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
                            if (_numberOfSets != _originalNumberOfSets) {
                              setState(() {
                                _numberOfSets++;
                              });
                              //TODO: stop timer
                            }
                          },
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_up,
                            color: Theme.of(context).primaryColorLight,
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
                            if (_numberOfSets != 0) {
                              setState(() {
                                _numberOfSets--;
                                //TODO: stop timer
                              });
                            }
                          },
                        )
                      : IconButton(
                          onPressed: () => null,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).primaryColorLight,
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

  Widget notesTile(HangboardExerciseLoaded state) {
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

//TODO: should this be separated from the widget in a dao?
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
