import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_bloc.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/frontend/widgets/circular_timer.dart';
import 'package:crux/frontend/widgets/exercise_tile.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardPage extends StatefulWidget {
  final int index;

  final String workoutTitle;
  final FirestoreHangboardWorkoutsRepository
  firestoreHangboardWorkoutsRepository;
  final HangboardExercise hangboardExercise;

  HangboardPage({
                  this.index,
                  this.workoutTitle,
                  this.hangboardExercise,
                  this.firestoreHangboardWorkoutsRepository,
                });

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState extends State<HangboardPage>
    with TickerProviderStateMixin {
  int _originalNumberOfSets;
  int _originalNumberOfHangs;

  AnimationController _timerController;

  TimerBloc _timerBloc;
  HangboardExerciseBloc _hangboardExerciseBloc;

  @override
  void initState() {
    _originalNumberOfSets = widget.hangboardExercise.numberOfSets;
    _originalNumberOfHangs = widget.hangboardExercise.hangsPerSet;

//    _timerBloc = TimerBloc(hangboardExerciseBloc: _hangboardExerciseBloc);
    _hangboardExerciseBloc = HangboardExerciseBloc(
        hangboardExercise: widget.hangboardExercise,
        firestore: widget.firestoreHangboardWorkoutsRepository)
      ..dispatch(LoadHangboardExercise(widget.hangboardExercise));
//    _hangboardExerciseBloc = BlocProvider.of<HangboardExerciseBloc>(context);

    _timerBloc = new TimerBloc()
      ..dispatch(LoadTimer(widget.hangboardExercise, false));

    _timerController = AnimationController(
        vsync: this,
        value: 1.0,
        duration: Duration(seconds: widget.hangboardExercise.restDuration),
        reverseDuration:
        Duration(seconds: widget.hangboardExercise.repDuration));

    super.initState();
  }

  Container hangboardPageWidgetTEMP(state) {
    return Container(
      child: ListView(
        children: <Widget>[
          titleTile(state),
          workoutTimerTile(state),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _hangboardExerciseBloc,
        builder: (BuildContext context, HangboardExerciseState state) {
          if(state is ReplaceWithRepTimer) {
            print("HBPAGE BUILDER");
            var repState = state as ReplaceWithRepTimer;
//            _timerController.duration =
//                Duration(seconds: repState.hangboardExercise.repDuration);
//            _timerController.value = 0.0;
          }
          if(state is ReplaceWithRestTimer) {
            print("HBPAGE BUILDER");
            var restState = state as ReplaceWithRestTimer;
//            _timerController.duration =
//                Duration(seconds: restState.hangboardExercise.restDuration);
//            _timerController.value = 1.0;
            return hangboardPageWidgetTEMP(state);
          }
          if(state is ReplaceWithBreakTimer) {
            print("HBPAGE BUILDER");
            return hangboardPageWidgetTEMP(state);
          }
          if(state is ClearTimerPreferences) {}
          if(state is HangboardExerciseLoaded) {
            //todo: need to check for sharedPrefs and load from there if possible
            return hangboardPageWidgetTEMP(state);
          } else {
            return Container();
          }
        });
  }

  Widget titleTile(HangboardExerciseLoaded state) {
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
                '${state.hangboardExercise.exerciseTitle}',
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

  Widget workoutTimerTile(HangboardExerciseLoaded hangboardState) {
    return BlocBuilder(
      bloc: _timerBloc,
      builder: (BuildContext context, TimerState timerState) {
        if(timerState is TimerLoaded) {
          print("TIME BUILDER");

          VoidCallback timerControllerCallback =
          setupTimerControllerCallback(hangboardState, timerState);

          if(timerState.isTimerRunning) {
            timerControllerCallback();
          }

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
                          child: CircularTimer(
                            timerController: _timerController,
                            timerControllerCallback: timerControllerCallback,
                            timerState: timerState,
                          ),
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
                              _hangboardExerciseBloc.dispatch(RepButtonPressed(
                                  hangboardState.hangboardExercise));
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
                              _hangboardExerciseBloc.dispatch(RestButtonPressed(
                                  hangboardState.hangboardExercise));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
//                  setCompleteNotifier(), //todo: don't know if this goes here but let's find out
                ],
              ),
            ),
          );
        } else {
          return loadingScreen();
        }
      },
    );
  }

  //todo: extract this to a bloc? pass timerController and just decide what to do
  VoidCallback setupTimerControllerCallback(
      HangboardExerciseLoaded hangboardState, TimerLoaded timerState) {
//    _timerController.value = timerState.controllerValue;
    if(timerState.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      return () {
        _timerController.reverse().whenComplete(() {
          if(_timerController.status == AnimationStatus.dismissed) {
            /// let bloc determine new exercise props and timer
            _hangboardExerciseBloc.dispatch(ReverseComplete(
              hangboardState.hangboardExercise,
              timerState.timer,
              _timerBloc,
            ));
          }
        }).catchError((error) {
          print('Timer failed animating counterclockwise: $error');
          _timerController.stop(canceled: false);
        });
      };
    } else {
      return () {
        _timerController.forward().whenComplete(() {
          if(_timerController.status == AnimationStatus.completed) {
            /// let bloc determine new exercise props and timer
            _hangboardExerciseBloc.dispatch(ForwardComplete(
              hangboardState.hangboardExercise,
              timerState.timer,
              _timerBloc,
            ));
          }

          //todo: make sure controller keeps animating with new timer
        }).catchError((error) {
          print('Timer failed animating clockwise: $error');
          _timerController.stop(canceled: false);
        });
      };
    }
  }

  Widget hangsAndResistanceTile(HangboardExerciseLoaded state) {
    var hangsPerSet = state.hangboardExercise.hangsPerSet;
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
                  hangsPerSet < _originalNumberOfHangs
                      ? IconButton(
                      icon: Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        if(hangsPerSet != _originalNumberOfHangs) {
                          _timerController.stop(canceled: false);
                          //todo: make sure i reset controller, not jsut stop it(use value method below if needed)
                          //_timerController.value();
                          _hangboardExerciseBloc.dispatch(
                              IncreaseNumberOfHangsButtonPressed(
                                  state.hangboardExercise));
//                          _timerBloc.dispatch(event) not sure if i need to interact w/ timerbloc here or not
                        }
                      })
                      : IconButton(
                    // Placeholder button that does nothing (can't go higher than originalNumberOfHangs)
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                  Text(
                    '$hangsPerSet',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  hangsPerSet > 0
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if(hangsPerSet != 0) {
                        _timerController.stop(canceled: false);
                        //_timerController.value();
                        _hangboardExerciseBloc.dispatch(
                            DecreaseNumberOfHangsButtonPressed(
                                state.hangboardExercise));
                        //todo: update here if above gets updated
                      }
                    },
                  )
                      : IconButton(
                    // Placeholder button that does nothing
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
                      StringFormatUtils.formatHangsAndResistance(
                          hangsPerSet,
                          state.hangboardExercise.resistance.toInt(),
                          state.hangboardExercise.resistanceMeasurementSystem),
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
    var numberOfSets = state.hangboardExercise.numberOfSets;

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
                  numberOfSets < _originalNumberOfSets
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_up),
                    onPressed: () {
                      if(numberOfSets != _originalNumberOfSets) {
                        _timerController.stop(canceled: false);
                        _hangboardExerciseBloc.dispatch(
                            IncreaseNumberOfSetsButtonPressed(
                                state.hangboardExercise));
                        //todo: update here if above gets updated
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
                    '$numberOfSets',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  numberOfSets > 0
                      ? IconButton(
                    icon: Icon(Icons.arrow_drop_down),
                    onPressed: () {
                      if(numberOfSets != 0) {
                        _timerController.stop(canceled: false);
                        _hangboardExerciseBloc.dispatch(
                            DecreaseNumberOfSetsButtonPressed(
                                state.hangboardExercise));
                        //todo: update here if above gets updated
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
                      numberOfSets == 1 ? ' Set' : ' Sets',
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

  Widget loadingScreen() {
    return Column(
      children: <Widget>[
        /*Empty to help avoid any flickering from quick loads*/
      ],
    );
  }

  /// Start time between sets and provide callback that decrements number of
  /// sets as well as resets number of hangs
  /// TODO: Figure this out - global listener? cancel at end of if block? both seem weird
  /*void setHangboardExerciseStreamListener() {
//    _hangsPerSet = _hangsPerSet > 0 ? (_hangsPerSet - 1) : 0;
    _hangboardExerciseStreamSubscription = _hangboardExerciseBloc.state
        .listen((state) {
      if(state is HangboardExerciseLoaded &&
          state.hangboardExercise.numberOfSets == 0) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Set Complete!',
                  style: TextStyle(
                      fontSize: 25.0, color: Theme
                      .of(context)
                      .accentColor),
                ),
              ],
            ),
          ),
        );
      }
    });
  }*/

  //todo: think i'm going to try this widget but might want to use above commented listener instead, not sure which one will work
  Widget setCompleteNotifier() {
    return BlocListener(
      bloc: _hangboardExerciseBloc,
      listener: (BuildContext context, HangboardExerciseState state) {
        if(state is HangboardExerciseLoaded &&
            state.hangboardExercise.numberOfSets == 0) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Set Complete!',
                    style: TextStyle(
                        fontSize: 25.0, color: Theme
                        .of(context)
                        .accentColor),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }


}
//TODO: need to make this a streamListener
/*Scaffold.of(context).showSnackBar(SnackBar(
  duration: Duration(days: 1),
  content: Row(),
  action: SnackBarAction(
  label: 'Next Exercise',
  onPressed: widget.nextPageCallback,
  ),
  ));*/

//  Widget

/*void notifyParentReverseComplete() {
    setState(() {
      

      
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
  }*/

/*void notifyParentForwardComplete() {
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
  }*/

/*void notifyParentForwardTimeBetweenSetsComplete() {
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
        //TODO: need to make this a streamListener
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
  }*/
