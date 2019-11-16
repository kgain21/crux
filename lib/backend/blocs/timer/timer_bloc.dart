import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/backend/services/preferences.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  /*final HangboardExerciseBloc hangboardExerciseBloc;
  StreamSubscription hangboardExerciseSubscription;

  /// Listens for [HangboardExercise] to be created before dispatching to
  /// [LoadTimer].
  TimerBloc({@required this.hangboardExerciseBloc}) {
    hangboardExerciseSubscription = hangboardExerciseBloc.state.listen((
        state) { //TODO: how often will this rebuild???
      if(state is HangboardExerciseLoaded) {
        dispatch(LoadTimer(state.hangboardExercise));
      }
    });
  }*/
  @override
  TimerState get initialState => TimerLoading();

  @override
  Stream<TimerState> mapEventToState(TimerEvent event) async* {
    if(event is LoadTimer) {
      yield* _mapLoadTimerToState(event);
    } else if(event is TimerComplete) {
      yield* _mapTimerCompleteToState(event);
    } else if(event is ReplaceWithRepTimer) {
      yield* _mapReplaceWithRepTimerToState(event);
    } else if(event is ReplaceWithRestTimer) {
      yield* _mapReplaceWithRestTimerToState(event);
    } else if(event is ReplaceWithBreakTimer) {
      yield* _mapReplaceWithBreakTimerToState(event);
    } else if(event is DisposeTimer) {
      yield* _mapDisposeTimerToState(event);
    } else if(event is ClearTimerPreferences) {
      yield* _mapClearTimerPreferencesToState(event);
    }
  }

  /// Loading the [Timer] assumes that this is the first time the user has// todo: <- not necessarily, if I'm listening to hbexerciseLoaded it should just pass in the new exercise each time and I can build off that right?
  /// interacted with this particular [Timer] since its workout has been loaded.
  /// [SharedPreferences] are checked and if none are found a [Timer] is created
  /// based on the [HangboardExerciseWorkout]. This [Timer] defaults to animating
  /// counterclockwise and starting with a controller value of 1.0 since these
  /// values signify a 'Rep'.
  ///
  /// If [SharedPreferences] are found, than the user has interacted with this
  /// [Timer] before and navigated away. The appropriate controller value is
  /// calculated based on how much time has elapsed and is passed back to
  /// the ExercisePage.
  Stream<TimerState> _mapLoadTimerToState(LoadTimer event) async* {
    try {
      final timerEntity = Preferences()
          .getTimerPreferences(event.hangboardExercise.exerciseTitle);

      if(timerEntity != null) {
        Timer timer = Timer.fromEntity(timerEntity);
        double controllerValue = determineControllerValue(timer);
        yield TimerLoaded(
            timer, controllerValue, timerEntity.previouslyRunning);
      } else {
        yield TimerLoaded(
            Timer(
              event.hangboardExercise.exerciseTitle,
              event.hangboardExercise.repDuration,
              TimerDirection.COUNTERCLOCKWISE,
              false,
              0,
              0.0,
            ),
            0.0,
            event.isTimerRunning);
      }
    } catch(exception) {
      print(exception);
      yield TimerNotLoaded();
    }
  }

  Stream<TimerState> _mapReplaceWithRepTimerToState(
      ReplaceWithRepTimer event) async* {
    yield TimerLoaded(
        Timer(
          event.hangboardExercise.exerciseTitle,
          event.hangboardExercise.repDuration,
          TimerDirection.COUNTERCLOCKWISE,
          false,
          0,
          0.0,
        ),
        0.0,
        event.isTimerRunning);
  }

  Stream<TimerState> _mapReplaceWithRestTimerToState(
      ReplaceWithRestTimer event) async* {
    yield TimerLoaded(
        Timer(
          event.hangboardExercise.exerciseTitle,
          event.hangboardExercise.restDuration,
          TimerDirection.CLOCKWISE,
          false,
          0,
          0.0,
        ),
        1.0,
        event.isTimerRunning);
  }

  Stream<TimerState> _mapReplaceWithBreakTimerToState(
      ReplaceWithBreakTimer event) async* {
    yield TimerLoaded(
        Timer(
          event.hangboardExercise.exerciseTitle,
          event.hangboardExercise.breakDuration,
          TimerDirection.CLOCKWISE,
          false,
          0,
          0.0,
        ),
        1.0,
        event.isTimerRunning);
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
    return Preferences()
        .storeTimerPreferences(timer.storageKey, timer.toEntity());
  }

  double determineControllerValue(Timer timer) {
    if(timer.previouslyRunning) {
      return valueDifference(timer);
    } else {
      return timer.controllerValueOnExit;
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
/*
  @override
  void dispose() {
    hangboardExerciseSubscription.cancel();
    super.dispose();
  }*/
}
