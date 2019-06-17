import 'dart:async';

import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:meta/meta.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {

  final HangboardExerciseBloc hangboardExerciseBloc;
  StreamSubscription hangboardExerciseSubscription;

  /// Listens for exercise to be created, then goes to SharedPreferences to look
  /// for any timer preferences.
  TimerBloc({@required this.hangboardExerciseBloc}) {
    hangboardExerciseSubscription = hangboardExerciseBloc.state.listen((state) {
      if(state is HangboardExerciseLoaded) {
        dispatch(LoadTimer(state.hangboardExercise.exerciseTitle));
      }
    });
  }

  @override
  TimerState get initialState => TimerLoading();

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if(event is LoadTimer) {
      yield* _mapLoadTimerToState(event);
    } else if(event is TimerComplete) {
      yield* _mapTimerCompleteToState(event);
    } else if(event is DisposeTimer) {
      yield* _mapDisposeTimerToState(event);
    } else if(event is ClearTimerPreferences) {
      yield* _mapClearTimerPreferencesToState(event);
    }
  }

  Stream<TimerState> _mapLoadTimerToState(LoadTimer event) async* {
    try {
      final timerEntity = Preferences().getTimerPreferences(event.storageKey);
      yield TimerLoaded(
          Timer.fromEntity(timerEntity)
      );
    }
    catch(exception) {
      print(exception);
      yield TimerNotLoaded();
    }
  }

  Stream<TimerState> _mapTimerCompleteToState(event) {
    return null;
  }

  Stream<TimerState> _mapClearTimerPreferencesToState(event) {
    return null;
  }

  Stream<TimerState> _mapDisposeTimerToState(DisposeTimer event) async* {
    if(currentState is TimerLoaded) {
      _saveTimer(event.timer);
      yield TimerDisposed();
    }
  }

  Future _saveTimer(Timer timer) {
    return Preferences().storeTimerPreferences(
        timer.storageKey, timer.toEntity());
  }

  @override
  void dispose() {
    hangboardExerciseSubscription.cancel();
    super.dispose();
  }
}


/// Gets the difference in time if timer was left running
/// Gets 0.0 or 1.0 if time was exceeded in either direction
/// Get value of animation if stopped
double value = getValueIfTimerPreviouslyRunning();

/// Resets value to 0.0 or 1.0 if one of the switch timer buttons was pressed
value

=

checkIfResetTimer(value);

/// Creates controller with appropriate animation value determined above
setupController(value);

double getValueIfTimerPreviouslyRunning() {
  if(_timerPreviouslyRunning) {
    return valueDifference();
  } else {
    return _endValue;
  }
}

/// Finds the difference in time from the saved ending system time and the
/// current system time and divides that by the starting duration to get the
/// new value accounting for elapsed time.
double valueDifference() {
  int currentTimeMillis = DateTime
      .now()
      .millisecondsSinceEpoch;
  int elapsedDuration = currentTimeMillis - _endTimeMillis;
  double endDuration = _endValue * (_currentTime * 1000.0);
  double value;

  /// If animating forward and the calculated value difference is less than 0,
  /// return 0.0 as the value (can't have a negative value).
  /// Else if difference is greater than 1, return 1.
  /// Finally, return calculated value if neither of the above are true.
  if(_forwardAnimation) {
    value = (endDuration + elapsedDuration) / (_currentTime * 1000.0);
    if(value <= 0.0) return 0.0;
  } else {
    value = (endDuration - elapsedDuration) / (_currentTime * 1000.0);
    if(value >= 1) return 1.0;
  }
  return value;
}

/// Creates an AnimationController based on whether or not the timer should
/// be animating forward or not. The duration is the rest duration if
/// forward, or rep duration if reverse. Value is calculated if the timer
/// was left running or retrieved from memory if stopped.
void setupController(double value) {
//    _controller = new AnimationController(
//        vsync: this, value: value, duration: Duration(seconds: _currentTime));

  _controller.value = value;
  _controller.duration = Duration(seconds: _currentTime);
  if(_timerPreviouslyRunning) {
    setupControllerCallback(_controller);
  }
}

/// Checks if switch flag was passed in - this should signal a new build of the
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
    /*if(!widget.startTimer)
        _timerPreviouslyRunning = false;*/

    _currentTime = widget.time;
    _forwardAnimation = widget.switchForward;
//      _controller.value = value;
//      _controller.duration = Duration(seconds: _currentTime);
  }
  return value;
}


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
      setTimerPreviouslyRunning(false);
      controller.stop(canceled: false);
    } else {
      setTimerPreviouslyRunning(true);
      setupControllerCallback(controller);
    }
  }
}

void setupControllerCallback(AnimationController controller) {
  if(!_forwardAnimation) {
    controller.reverse().whenComplete(() {
      if(controller.status == AnimationStatus.dismissed) {
        _preferences.setTimerPreviouslyRunning(true);
        setTime(null);
        setEndValue(null);
        setEndTimeMillis(null);
        if(widget.notifyParentReverseComplete != null) {
          widget.notifyParentReverseComplete();
        }
      }
    }).catchError((error) {
      print('Timer failed animating in reverse: $error');
      startStopTimer(_controller);
    });
  } else {
    controller.forward().whenComplete(() {
      if(controller.status == AnimationStatus.completed) {
        setTimerPreviouslyRunning(true);
        setTime(null);
        setEndValue(null);
        setEndTimeMillis(null);
        if(widget.notifyParentForwardComplete != null) {
          widget.notifyParentForwardComplete();
        }
      }
    }).catchError((error) {
      print('Timer failed animating forward: $error');
      startStopTimer(_controller);
    });
  }
}

//TODO: make this do more
void handleError(Error error) {
  startStopTimer(_controller);
}

/// Resets the timer based on its current status. This method is passed to the
/// onLongPress event of the circular timer.
void resetTimer(AnimationController controller) {
  setTimerPreviouslyRunning(false);
  if(controller.isAnimating) {
    controller.stop(canceled: false);
    if(controller.status == AnimationStatus.reverse) {
      setState(() {
        controller.value = 1.0;
      });
    } else if(controller.status == AnimationStatus.forward) {
      setState(() {
        controller.value = 0.0;
      });
    }
  } else {
    if(controller.status == AnimationStatus.reverse) {
      setState(() {
        controller.value = 1.0;
      });
    } else if(controller.status == AnimationStatus.forward) {
      setState(() {
        controller.value = 0.0;
      });
    }
  }
}}