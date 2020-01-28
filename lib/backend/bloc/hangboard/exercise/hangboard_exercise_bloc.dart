import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/hangboard/exercise/hangboard_exercise_state.dart';
import 'package:crux/backend/bloc/timer/timer_event.dart';

import 'hangboard_exercise_event.dart';
import 'hangboard_exercise_state.dart';

class HangboardExerciseBloc
    extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
//  final FirestoreHangboardWorkoutsRepository firestore;
//  final HangboardExercise hangboardExercise;

  int originalNumberOfHangs;
  int originalNumberOfSets;

//
//  HangboardExerciseBloc({
//                          @required this.firestore,
//                          this.hangboardExercise,
//                        });

  /* /// SINGLETON
  static final HangboardExerciseBloc _hangboardExerciseBloc = HangboardExerciseBloc._internal();

  factory HangboardExerciseBloc() {
    return _hangboardExerciseBloc;
  }

  HangboardExerciseBloc._internal();*/

  @override
  HangboardExerciseState get initialState => HangboardExerciseLoadInProgress();

  @override
  Stream<HangboardExerciseState> mapEventToState(
      HangboardExerciseEvent event) async* {
    if (event is HangboardExerciseLoaded) {
      yield* _mapLoadHangboardExerciseToState(event);
    } else if (event is HangboardExercisePreferencesCleared) {
      yield* _mapClearHangboardExercisePreferencesToState(event);
    } else if (event is HangboardExerciseIncreaseNumberOfHangsButtonPressed) {
      yield* _mapHangboardExerciseIncreaseNumberOfHangsButtonPressedToState(
          event);
    } else if (event is HangboardExerciseDecreaseNumberOfHangsButtonPressed) {
      yield* _mapHangboardExerciseDecreaseNumberOfHangsButtonPressedToState(
          event);
    } else if (event is HangboardExerciseIncreaseNumberOfSetsButtonPressed) {
      yield* _mapHangboardExerciseIncreaseNumberOfSetsButtonPressedToState(
          event);
    } else if (event is HangboardExerciseDecreaseNumberOfSetsButtonPressed) {
      yield* _mapHangboardExerciseDecreaseNumberOfSetsButtonPressedToState(
          event);
    } else if (event is HangboardExerciseForwardComplete) {
      yield* _mapForwardCompletedToState(event);
    } else if (event is HangboardExerciseReverseComplete) {
      yield* _mapHangboardExerciseReverseCompleteToState(event);
    } else if (event is HangboardExerciseForwardSwitchButtonPressed) {
      yield* _mapHangboardExerciseForwardSwitchButtonPressedToState(event);
    } else if (event is HangboardExerciseReverseSwitchButtonPressed) {
      yield* _mapHangboardExerciseReverseSwitchButtonPressedToState(event);
    }
  }

  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState(
      HangboardExerciseLoaded event) async* {
    try {
      originalNumberOfSets = event.hangboardExercise.numberOfSets;
      originalNumberOfHangs = event.hangboardExercise.hangsPerSet;
      yield HangboardExerciseLoadSuccess(event.hangboardExercise);
    } catch(_) {
      yield HangboardExerciseLoadFailure();
    }
  }

/*
  Stream<HangboardExerciseState> _mapHangboardExerciseCompleteToState(event) {
    return null;
  }*/

  Stream<HangboardExerciseState> _mapClearHangboardExercisePreferencesToState(
      event) async* {
    yield null;
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseIncreaseNumberOfHangsButtonPressedToState(
      HangboardExerciseIncreaseNumberOfHangsButtonPressed event) async* {
    var updatedHangsPerSet = event.exercise.hangsPerSet;
    if(updatedHangsPerSet < originalNumberOfHangs) {
      updatedHangsPerSet++;
    }
    yield HangboardExerciseLoadSuccess(
        event.exercise.copyWith(hangsPerSet: updatedHangsPerSet));
    event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseDecreaseNumberOfHangsButtonPressedToState(
      HangboardExerciseDecreaseNumberOfHangsButtonPressed event) async* {
    var updatedHangsPerSet = event.exercise.hangsPerSet;
    if(updatedHangsPerSet > 0) {
      updatedHangsPerSet--;
    }
    yield HangboardExerciseLoadSuccess(
        event.exercise.copyWith(hangsPerSet: updatedHangsPerSet));
    event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseIncreaseNumberOfSetsButtonPressedToState(
      HangboardExerciseIncreaseNumberOfSetsButtonPressed event) async* {
    var updatedNumberOfSets = event.exercise.numberOfSets;
    if(updatedNumberOfSets < originalNumberOfSets) {
      updatedNumberOfSets++;
    }
    yield HangboardExerciseLoadSuccess(
        event.exercise.copyWith(numberOfSets: updatedNumberOfSets));
    event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseDecreaseNumberOfSetsButtonPressedToState(
      HangboardExerciseDecreaseNumberOfSetsButtonPressed event) async* {
    var updatedNumberOfSets = event.exercise.numberOfSets;
    if(updatedNumberOfSets > 0) {
      updatedNumberOfSets--;
    }
    yield HangboardExerciseLoadSuccess(
        event.exercise.copyWith(numberOfSets: updatedNumberOfSets));
    event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseForwardSwitchButtonPressedToState(
      HangboardExerciseForwardSwitchButtonPressed event) async* {
    yield HangboardExerciseLoadSuccess(event.exercise);
    event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, false));
    //todo: if this is pressed after a replaceWithRepTimer event has just happened
    //todo: the state hasn't changed so nothing happens and it doesnt update
  }

  Stream<HangboardExerciseState>
  _mapHangboardExerciseReverseSwitchButtonPressedToState(
      HangboardExerciseReverseSwitchButtonPressed event) async* {
    yield HangboardExerciseLoadSuccess(event.exercise);
    event.timerBloc.add(TimerReplacedWithRestTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapForwardCompletedToState(
      HangboardExerciseForwardComplete event) async* {
    var hangs = event.exercise.hangsPerSet;
    var sets = event.exercise.numberOfSets;

    /// Rest timer completing
    if(event.timer.duration == event.exercise.restDuration) {
      if(hangs > 0) {
        hangs--;
        yield HangboardExerciseLoadSuccess(
            event.exercise.copyWith(hangsPerSet: hangs));
        event.timerBloc.add(TimerReplacedWithRepTimer(event.exercise, true));
      } else {
        yield HangboardExerciseLoadSuccess(
            event.exercise.copyWith(hangsPerSet: hangs));
        event.timerBloc.add(TimerReplacedWithBreakTimer(event.exercise, true));
      }
    } else {
      /// Break timer completing
      if(sets > 0) {
        sets--;
        yield HangboardExerciseLoadSuccess(event.exercise.copyWith(
          hangsPerSet: originalNumberOfHangs,
          numberOfSets: sets,
        ));
        event.timerBloc.add(TimerReplacedWithRepTimer(
            event.exercise.copyWith(numberOfSets: sets), true));
      } else {
        // todo: - just removes screen - figure out better solution
        yield HangboardExerciseLoadFailure();
      }
    }
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseReverseCompleteToState(
      HangboardExerciseReverseComplete event) async* {
    /// Rep timer completing always results in restTimer
    yield HangboardExerciseLoadSuccess(event.exercise);
    event.timerBloc.add(TimerReplacedWithRestTimer(event.exercise, true));
  }
}
