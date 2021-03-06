import 'package:crux/backend/bloc/hangboard/exercise/hangboard_exercise_bloc.dart';
import 'package:crux/backend/bloc/hangboard/exercise/hangboard_exercise_event.dart';
import 'package:crux/backend/bloc/hangboard/exercise/hangboard_exercise_state.dart';
import 'package:crux/backend/bloc/timer/timer_bloc.dart';
import 'package:crux/backend/bloc/timer/timer_event.dart';
import 'package:crux/backend/bloc/timer/timer_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/frontend/widgets/circular_timer.dart';
import 'package:crux/frontend/widgets/exercise_tile.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardPage extends StatefulWidget {
  final int index;

  final String workoutTitle;
  final HangboardExercise hangboardExercise;

  HangboardPage({
    this.index,
    this.workoutTitle,
    this.hangboardExercise,
  });

  @override
  State<HangboardPage> createState() => _HangboardPageState();
}

class _HangboardPageState extends State<HangboardPage>
    with TickerProviderStateMixin {
  AnimationController _timerController;

  TimerBloc _timerBloc;
  HangboardExerciseBloc _hangboardExerciseBloc;

  @override
  void initState() {
//    _timerBloc = TimerBloc(hangboardExerciseBloc: _hangboardExerciseBloc);
    _hangboardExerciseBloc = HangboardExerciseBloc(
        /*hangboardExercise: widget.hangboardExercise,
        firestore: widget.firestoreHangboardWorkoutsRepository*/
        )
      ..add(HangboardExerciseLoaded(widget.hangboardExercise));
//    _hangboardExerciseBloc = BlocProvider.of<HangboardExerciseBloc>(context);

    _timerBloc = new TimerBloc()
      ..add(TimerLoaded(widget.hangboardExercise, false));

    _timerController = AnimationController(
        vsync: this,
        value: 1.0,
        duration: Duration(seconds: widget.hangboardExercise.restDuration),
        reverseDuration:
            Duration(seconds: widget.hangboardExercise.repDuration));

    super.initState();
  }

  @override
  void dispose() {
//    _timerBloc.add(DisposeTimer());
//    _hangboardExerciseBloc.add(DisposeHangboardExercise());
    _timerBloc.close();
    _hangboardExerciseBloc.close();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _hangboardExerciseBloc,
      listener: (BuildContext context, HangboardExerciseState state) {
        if(state is HangboardExerciseLoadSuccess &&
            state.hangboardExercise.hangsPerSet == 0) {
          _showSetCompleteSnackBar(context);
        }
      },
      child: BlocBuilder(
        bloc: _hangboardExerciseBloc,
        builder: (BuildContext context, HangboardExerciseState state) {
          if(state is HangboardExercisePreferencesCleared) {}
          if(state is HangboardExerciseLoadSuccess) {
            //todo: need to check for sharedPrefs and load from there if possible
            return _buildHangboardPage(state);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Container _buildHangboardPage(state) {
    return Container(
      child: ListView(
        children: <Widget>[
          _titleTile(state),
          _workoutTimerTile(state),
          IntrinsicHeight(
            child: Row(
              children: <Widget>[
                _hangsAndResistanceTile(state),
                _setsTile(state),
              ],
            ),
          ),
          _notesTile(state),
        ],
      ),
    );
  }

  Widget _titleTile(HangboardExerciseLoadSuccess state) {
    return ExerciseTile(
      tileColor: Theme
          .of(context)
          .accentColor,
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .width / 6.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            MediaQuery
                .of(context)
                .size
                .width / 35,
            MediaQuery
                .of(context)
                .size
                .height / 70,
            MediaQuery
                .of(context)
                .size
                .width / 35,
            MediaQuery
                .of(context)
                .size
                .height / 70,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${state.hangboardExercise.exerciseTitle}',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 17.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workoutTimerTile(HangboardExerciseLoadSuccess hangboardState) {
    return BlocBuilder(
      bloc: _timerBloc,
      builder: (BuildContext context, TimerState timerState) {
        if(timerState is TimerLoadSuccess) {
          VoidCallback timerControllerCallback =
          _determineTimerAnimation(hangboardState, timerState);

          if(timerState.timer.isTimerRunning) {
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
                  _workoutTimer(context, timerControllerCallback, timerState),
                  _timerSwitchButtons(hangboardState),
                ],
              ),
            ),
          );
        } else {
          return _loadingScreen();
        }
      },
    );
  }

  /// Creates the function for animating the timer based on the current state
  /// of the timer and hangboardExercise. When the function completes, an event
  /// is dispatched to update the state.
  ///
  /// This was extracted out of the [CircularTimer] so that the [HangboardPage]
  /// could also make use of the animation controller. It ended up being easier
  /// to define the controller at a higher level and pass it down to the timer.
  VoidCallback _determineTimerAnimation(
      HangboardExerciseLoadSuccess hangboardExerciseState,
      TimerLoadSuccess timerState) {
    _timerController.value = timerState.controllerValue;

    if(timerState.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      _timerController.reverseDuration =
          Duration(seconds: timerState.timer.duration);
      return () {
        _timerController.reverse().whenComplete(() {
          if(_timerController.status == AnimationStatus.dismissed) {
            _hangboardExerciseBloc.add(HangboardExerciseReverseComplete(
              hangboardExerciseState.hangboardExercise,
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
      _timerController.duration = Duration(seconds: timerState.timer.duration);
      return () {
        _timerController.forward().whenComplete(() {
          if(_timerController.status == AnimationStatus.completed) {
            _hangboardExerciseBloc.add(HangboardExerciseForwardComplete(
              hangboardExerciseState.hangboardExercise,
              timerState.timer,
              _timerBloc,
            ));
          }
        }).catchError((error) {
          print('Timer failed animating clockwise: $error');
          _timerController.stop(canceled: false);
        });
      };
    }
  }

  /// Positions and scales the [CircularTimer] for the [HangboardPage]
  Positioned _workoutTimer(BuildContext context,
      VoidCallback timerControllerCallback, TimerLoadSuccess timerState) {
    return Positioned(
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
    );
  }

  Positioned _timerSwitchButtons(HangboardExerciseLoadSuccess hangboardState) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: MediaQuery
                    .of(context)
                    .size
                    .width / 15.0,
              ),
              onPressed: () {
                _hangboardExerciseBloc.add(
                    HangboardExerciseForwardSwitchButtonPressed(
                        hangboardState.hangboardExercise, _timerBloc));
              },
            ),
            IconButton(
              icon: Icon(
                IconData(
                  0xe5d5,
                  fontFamily: 'MaterialIcons',
                  matchTextDirection: true,
                ),
                size: MediaQuery
                    .of(context)
                    .size
                    .width / 15.0,
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                _hangboardExerciseBloc.add(
                    HangboardExerciseReverseSwitchButtonPressed(
                        hangboardState.hangboardExercise, _timerBloc));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _hangsAndResistanceTile(HangboardExerciseLoadSuccess state) {
    var currentHangsPerSet = state.hangboardExercise.hangsPerSet;
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
                  currentHangsPerSet <
                      _hangboardExerciseBloc.originalNumberOfHangs
                      ? IconButton(
                      icon: Icon(
                        Icons.arrow_drop_up,
                        size: MediaQuery
                            .of(context)
                            .size
                            .width / 15.0,
                      ),
                      onPressed: () {
                        if(currentHangsPerSet !=
                            _hangboardExerciseBloc.originalNumberOfHangs) {
                          _timerController.stop(canceled: false);
                          _hangboardExerciseBloc.add(
                              HangboardExerciseIncreaseNumberOfHangsButtonPressed(
                                  state.hangboardExercise, _timerBloc));
                        }
                      })
                      : IconButton(

                    /// Placeholder button that does nothing
                    /// (can't go higher than originalNumberOfHangs)
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                  Text(
                    '$currentHangsPerSet',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  currentHangsPerSet > 0
                      ? IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
                    ),
                    onPressed: () {
                      if(currentHangsPerSet != 0) {
                        _timerController.stop(canceled: false);
                        _hangboardExerciseBloc.add(
                            HangboardExerciseDecreaseNumberOfHangsButtonPressed(
                                state.hangboardExercise, _timerBloc));
                      }
                    },
                  )
                      : IconButton(

                    /// Placeholder button that does nothing
                    /// (can't go lower than originalNumberOfHangs)
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
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
                          currentHangsPerSet,
                          state.hangboardExercise.resistance.toInt(),
                          state.hangboardExercise.resistanceMeasurementSystem),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width / 20.0),
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

  Widget _setsTile(HangboardExerciseLoadSuccess state) {
    var currentNumberOfSets = state.hangboardExercise.numberOfSets;

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
                  currentNumberOfSets <
                      _hangboardExerciseBloc.originalNumberOfSets
                      ? IconButton(
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
                    ),
                    onPressed: () {
                      if(currentNumberOfSets !=
                          _hangboardExerciseBloc.originalNumberOfSets) {
                        _timerController.stop(canceled: false);
                        _hangboardExerciseBloc.add(
                            HangboardExerciseIncreaseNumberOfSetsButtonPressed(
                                state.hangboardExercise, _timerBloc));
                      }
                    },
                  )
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_up,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
                      color: Theme
                          .of(context)
                          .primaryColorLight,
                    ),
                  ),
                  Text(
                    '$currentNumberOfSets',
                    style: TextStyle(
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width / 12.0,
                    ),
                  ),
                  currentNumberOfSets > 0
                      ? IconButton(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
                    ),
                    onPressed: () {
                      if(currentNumberOfSets != 0) {
                        _timerController.stop(canceled: false);
                        _hangboardExerciseBloc.add(
                            HangboardExerciseDecreaseNumberOfSetsButtonPressed(
                                state.hangboardExercise, _timerBloc));
                      }
                    },
                  )
                      : IconButton(
                    onPressed: () => null,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: MediaQuery
                          .of(context)
                          .size
                          .width / 15.0,
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
                      currentNumberOfSets == 1 ? ' Set' : ' Sets',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width / 20.0),
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

  Widget _notesTile(HangboardExerciseLoadSuccess state) {
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

  Widget _loadingScreen() {
    return Column(
      children: <Widget>[
        /*Empty to help avoid any flickering from quick loads*/
      ],
    );
  }

  void _showSetCompleteSnackBar(BuildContext context) {
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
}
