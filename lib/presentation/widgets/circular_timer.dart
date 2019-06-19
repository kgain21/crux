import 'package:crux/backend/blocs/timer/timer_bloc.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/utils/timer_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircularTimer extends StatelessWidget {
  final AnimationController controller;

  CircularTimer({
                  this.controller,
                });

  //TimerBloc _timerBloc;

  /*bool _forwardAnimation;
  int _endTimeMillis;
  bool _timerPreviouslyRunning;
  String _id;
  double _endValue;
  int _currentTime;*/

  //Preferences _preferences;

/*
  @override
  void initState() {
    print('Timer ${widget.timer.storageKey} initState');

    _timerBloc = TimerBloc(preferences: Preferences());


    super.initState();
  }
*/

  @override
  Widget build(BuildContext context) {
//    print('Timer ${timer.storageKey} build');
    final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);

    return BlocBuilder(
      bloc: timerBloc,
      builder: (BuildContext context, TimerState state) {
        if(state is TimerLoading) {
          return loadingScreen();
        } else if(state is TimerLoaded) {
          return GestureDetector(
            onTap: () {
              startStopTimer(controller);
            },
            onLongPress: () {
              resetTimer(controller);
//              timerBloc.dispatch(ResetTimer(timer.copyWith()))
            },
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  circularTimer(),
                  timerText(state),
                ],
              ),
            ),
          );
        } else {
          //TODO: figure out if this is what i want
          return loadingScreen();
        }
      },
    );
  }

  /// Widget that builds a circular timer using [TimerPainter]. This timer is
  /// controlled by the [_controller] and is the main visual component of the
  /// [WorkoutTimer].
  Widget circularTimer() {
    return Positioned(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: TimerPainter(
              animation: controller,
              backgroundColor: Theme
                  .of(context)
                  .canvasColor,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme
                      .of(context)
                      .primaryColorLight,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget that builds the [timerString] for the [WorkoutTimer].
  /// The string is displayed in Minutes:Seconds and is controlled
  /// by [_controller].
  Widget timerText(TimerLoaded state) {
    return Align(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return Text(
                timerString(state),
                style: TextStyle(
                  fontSize: 50.0,
                ),
              );
            },
          )
        ],
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

  String timerString(TimerLoaded state) {
    Duration duration;
    if(state.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      duration = controller.duration * (1 - controller.value);
    } else {
      duration = controller.duration * controller.value;
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0')}';
  }

  Widget workoutTimer(SharedPreferences preferences) {
    ///retrieve prefs from device or set defaults if not present
//    getSharedPrefs(preferences);

    /// Gets the difference in time if timer was left running
    /// Gets 0.0 or 1.0 if time was exceeded in either direction
    /// Get value of animation if stopped
//    double value = getValueIfTimerPreviouslyRunning();

    /// Resets value to 0.0 or 1.0 if one of the switch timer buttons was pressed
//    value = checkIfResetTimer(value);

    /// Creates controller with appropriate animation value determined above
    setupController(value);

    // checkIfPreviouslyRunning();
    // checkIfShouldStart();

  }

  //TODO: STEP 1
  double determineControllerValue(TimerLoaded state) {
    if(state.timer.previouslyRunning) {
      return valueDifference(state.timer);
    } else {
      return state.timer.controllerValueOnExit;
    }
  }

  /// Finds the difference in time from the saved ending system time and the
  /// current system time and divides that by the starting duration to get the
  /// new value accounting for elapsed time.
  double valueDifference(Timer timer) {
    int currentTimeMillis = DateTime
        .now()
        .millisecondsSinceEpoch;

    int elapsedDuration = currentTimeMillis - timer.deviceTimeOnExit;

    double timerDurationOnExit =
        timer.controllerValueOnExit * (timer.duration * 1000.0);

    double value;

    /// If animating forward and the calculated value difference is less than 0,
    /// return 0.0 as the value (can't have a negative value).
    /// Else if difference is greater than 1, return 1.
    /// Finally, return calculated value if neither of the above are true.
    if(timer.direction == TimerDirection.CLOCKWISE) {
      value =
          (timerDurationOnExit + elapsedDuration) / (timer.duration * 1000.0);
      if(value <= 0.0) return 0.0;
    } else {
      value =
          (timerDurationOnExit - elapsedDuration) / (timer.duration * 1000.0);
      if(value >= 1) return 1.0;
    }
    return value;
  }

  /*@override
  void dispose() {
    print('Timer ${widget.id} dispose');
    setSharedPrefsBeforeDispose();

    if(_controller != null) {
      _controller.stop();
      _controller.dispose();
    }

    super.dispose();
  }*/

  /*vvv INITSTATE METHODS vvv*/
//  Started waiting for sharedPrefs to come back in build so everything that was
//  here went to the build methods
  /*^^^ INITSTATE METHODS ^^^*/

  /*vvv BUILD METHODS vvv*/

  /*/// Get all sharedPrefs at once during build
  void getSharedPrefs(SharedPreferences preferences) {
    _endTimeMillis = (preferences.getInt('$_id EndTimeMillis') ?? 0);

    _forwardAnimation = (preferences.getBool('$_id ForwardAnimation') ?? false);

    _timerPreviouslyRunning =
    (preferences.getBool('$_id TimerPreviouslyRunning') ?? false);

    /// If there is no endValue stored, check forwardAnimation and set to
    /// appropriate start value
    _endValue = (preferences.getDouble('$_id EndValue') ??
        (_forwardAnimation ? 0.0 : 1.0));

    /// This is for reloading an already running timer.
    /// The assumption is that if there is a value here the timer was left in a
    /// running state and needs to use this value.
    /// Otherwise, rebuild the timer with whatever new time came in.
    _currentTime = (preferences.getInt('$_id Time')) ?? widget.time;
  }*/



  /// Creates an AnimationController based on whether or not the timer should
  /// be animating forward or not. The duration is the rest duration if
  /// forward, or rep duration if reverse. Value is calculated if the timer
  /// was left running or retrieved from memory if stopped.

  //TODO: STEP 2 (???)
  void setupController(double value, TimerLoaded state) {
    controller.value = value;
    controller.duration = Duration(seconds: state.timer.duration);
    if(state.timer.previouslyRunning) {
      setupControllerCallback(controller, state.timer);
    }
  }

  void setupControllerCallback(AnimationController controller, Timer timer) {
    if(timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      controller.reverse().whenComplete(() {
        //TODO: left off here 6/19 => trying to decide how to handle this. Does exercise pass in callback?
        //TODO: dispatch to timerComplete? dispatch to exercise? need to figure this out
        if(controller.status == AnimationStatus.dismissed) {
          /*_preferences.setTimerPreviouslyRunning(true);
          setTime(null);
          setEndValue(null);
          setEndTimeMillis(null);
          if (widget.notifyParentReverseComplete != null) {
            widget.notifyParentReverseComplete();
          }*/
        }
      }).catchError((error) {
        print('Timer failed animating counterclockwise: $error');
        startStopTimer(controller);
      });
    } else {
      controller.forward().whenComplete(() {
        if(controller.status == AnimationStatus.completed) {
          /*setTimerPreviouslyRunning(true);
          setTime(null);
          setEndValue(null);
          setEndTimeMillis(null);
          if (widget.notifyParentForwardComplete != null) {
            widget.notifyParentForwardComplete();
          }*/
        }
      }).catchError((error) {
        print('Timer failed animating clockwise: $error');
        startStopTimer(controller);
      });
    }
  }

/*  /// Checks if switch flag was passed in - this should signal a new build of the
  /// timer with the passed in new time and opposite direction.
  ///
  /// Since the timer only rebuilds when being switched, the [switchTimer] flag
  /// will always start false at initialization and become true from the first
  /// user switch up until it is disposed of.
  /// The only flag that will change is the [switchForward] flag each time the
  /// user switches times.
  ///
  /// If the timer finished, the callback uses the [switchTimer] method which
  /// may also pass in the [startTimer] flag. This signals that the timer should
  /// start up immediately to keep the workout going smoothly.
  double checkIfResetTimer(double value) {
    if(widget.switchTimer) {
//      double value;
      if(widget.switchForward) {
        value = 0.0;
      } else {
        value = 1.0;
      }
      */ /*if(!widget.startTimer)
        _timerPreviouslyRunning = false;*/ /*

      _currentTime = widget.time;
      _forwardAnimation = widget.switchForward;
//      _controller.value = value;
//      _controller.duration = Duration(seconds: _currentTime);
    }
    return value;
  }*/

  /// Controls starting or stopping the [_controller] and determines which
  /// way it should animate using the boolean [_forwardAnimation], where true is
  /// forward and false is reverse. This method is passed to the onClickEvent
  /// of the [WorkoutTimer].
  ///
  /// When the animation completes, a notification is sent to the parent
  /// [WorkoutScreen] widget to tell it that it has finished.
  ///
  /// Additionally, the [SharedPreferences] get nulled out so that future timers
  /// don't try to read old values.
  void startStopTimer(AnimationController controller) {
    if(controller != null) {
      if(controller.isAnimating) {
//        setTimerPreviouslyRunning(false);

        controller.stop(canceled: false);
      } else {
//        setTimerPreviouslyRunning(true);
        setupControllerCallback(controller);
      }
    }
  }


  //TODO: make this do more
  void handleError(Error error) {
    startStopTimer(controller);
  }

  /// Resets the timer based on its current status. This method is passed to the
  /// onLongPress event of the circular timer.
  void resetTimer(AnimationController controller) {
//    setTimerPreviouslyRunning(false);
    if(controller.isAnimating) {
      controller.stop(canceled: false);
      if(controller.status == AnimationStatus.reverse) {
        /*setState(() {
          controller.value = 1.0;
        });*/
      } else if(controller.status == AnimationStatus.forward) {
        /*setState(() {
          controller.value = 0.0;
        });*/
      }
    } else {
      if(controller.status == AnimationStatus.reverse) {
        /*setState(() {
          controller.value = 1.0;
        });*/
      } else if(controller.status == AnimationStatus.forward) {
        /*setState(() {
          controller.value = 0.0;
        });*/
      }
    }
  }

/*^^^ BUILD METHODS ^^^*/

/*vvv DISPOSE METHODS vvv*/
  void setSharedPrefsBeforeDispose() {
    /*setForwardAnimation(_forwardAnimation);
    setEndValue(_controller.value ?? 0.0);
    setEndTimeMillis(DateTime.now().millisecondsSinceEpoch);
    setTime(_currentTime);*/
  }

/*^^^ DISPOSE METHODS ^^^*/
}
