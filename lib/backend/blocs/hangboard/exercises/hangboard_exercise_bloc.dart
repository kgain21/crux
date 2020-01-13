import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';

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
  HangboardExerciseState get initialState => HangboardExerciseLoading();

  @override
  Stream<HangboardExerciseState> mapEventToState(
      HangboardExerciseEvent event) async* {
    if (event is LoadHangboardExercise) {
      yield* _mapLoadHangboardExerciseToState(event);
    } else if (event is ClearHangboardExercisePreferences) {
      yield* _mapClearHangboardExercisePreferencesToState(event);
    } else if (event is IncreaseNumberOfHangsButtonPressed) {
      yield* _mapIncreaseNumberOfHangsButtonPressedToState(event);
    } else if (event is DecreaseNumberOfHangsButtonPressed) {
      yield* _mapDecreaseNumberOfHangsButtonPressedToState(event);
    } else if (event is IncreaseNumberOfSetsButtonPressed) {
      yield* _mapIncreaseNumberOfSetsButtonPressedToState(event);
    } else if (event is DecreaseNumberOfSetsButtonPressed) {
      yield* _mapDecreaseNumberOfSetsButtonPressedToState(event);
    } else if (event is ForwardComplete) {
      yield* _mapForwardCompletedToState(event);
    } else if (event is ReverseComplete) {
      yield* _mapReverseCompletedToState(event);
    } else if (event is ForwardSwitchButtonPressed) {
      yield* _mapForwardSwitchButtonPressedToState(event);
    } else if (event is ReverseSwitchButtonPressed) {
      yield* _mapReverseSwitchButtonPressedToState(event);
    }
  }

  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState(
      LoadHangboardExercise event) async* {
    try {
      originalNumberOfSets = event.hangboardExercise.numberOfSets;
      originalNumberOfHangs = event.hangboardExercise.hangsPerSet;
      yield HangboardExerciseLoaded(event.hangboardExercise);
    } catch(_) {
      yield HangboardExerciseNotLoaded();
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

  Stream<HangboardExerciseState> _mapIncreaseNumberOfHangsButtonPressedToState(
      IncreaseNumberOfHangsButtonPressed event) async* {
    var updatedHangsPerSet = event.exercise.hangsPerSet;
    if(updatedHangsPerSet < originalNumberOfHangs) {
      updatedHangsPerSet++;
    }
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: updatedHangsPerSet));
    event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapDecreaseNumberOfHangsButtonPressedToState(
      DecreaseNumberOfHangsButtonPressed event) async* {
    var updatedHangsPerSet = event.exercise.hangsPerSet;
    if(updatedHangsPerSet > 0) {
      updatedHangsPerSet--;
    }
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: updatedHangsPerSet));
    event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapIncreaseNumberOfSetsButtonPressedToState(
      IncreaseNumberOfSetsButtonPressed event) async* {
    var updatedNumberOfSets = event.exercise.numberOfSets;
    if(updatedNumberOfSets < originalNumberOfSets) {
      updatedNumberOfSets++;
    }
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(numberOfSets: updatedNumberOfSets));
    event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapDecreaseNumberOfSetsButtonPressedToState(
      DecreaseNumberOfSetsButtonPressed event) async* {
    var updatedNumberOfSets = event.exercise.numberOfSets;
    if(updatedNumberOfSets > 0) {
      updatedNumberOfSets--;
    }
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(numberOfSets: updatedNumberOfSets));
    event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapForwardSwitchButtonPressedToState(
      ForwardSwitchButtonPressed event) async* {
    yield HangboardExerciseLoaded(event.exercise);
    event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, false));
    //todo: if this is pressed after a replaceWithRepTimer event has just happened
    //todo: the state hasn't changed so nothing happens and it doesnt update
  }

  Stream<HangboardExerciseState> _mapReverseSwitchButtonPressedToState(
      ReverseSwitchButtonPressed event) async* {
    yield HangboardExerciseLoaded(event.exercise);
    event.timerBloc.dispatch(ReplaceWithRestTimer(event.exercise, false));
  }

  Stream<HangboardExerciseState> _mapForwardCompletedToState(
      ForwardComplete event) async* {
    var hangs = event.exercise.hangsPerSet;
    var sets = event.exercise.numberOfSets;

    /// Rest timer completing
    if(event.timer.duration == event.exercise.restDuration) {
      if(hangs > 0) {
        hangs--;
        yield HangboardExerciseLoaded(
            event.exercise.copyWith(hangsPerSet: hangs));
        event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, true));
      } else {
        yield HangboardExerciseLoaded(
            event.exercise.copyWith(hangsPerSet: hangs));
        event.timerBloc.dispatch(ReplaceWithBreakTimer(event.exercise, true));
      }
    } else {
      /// Break timer completing
      if(sets > 0) {
        sets--;
        yield HangboardExerciseLoaded(event.exercise.copyWith(
          hangsPerSet: originalNumberOfHangs,
          numberOfSets: sets,
        ));
        event.timerBloc.dispatch(ReplaceWithRepTimer(
            event.exercise.copyWith(numberOfSets: sets), true));
      } else {
        // todo: - just removes screen - figure out better solution
        yield HangboardExerciseNotLoaded();
      }
    }
  }

  Stream<HangboardExerciseState> _mapReverseCompletedToState(
      ReverseComplete event) async* {
    /// Rep timer completing always results in restTimer
    yield HangboardExerciseLoaded(event.exercise);
    event.timerBloc.dispatch(ReplaceWithRestTimer(event.exercise, true));
  }
}
