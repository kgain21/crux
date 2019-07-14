import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardExerciseBloc
    extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
  final FirestoreHangboardWorkoutsRepository firestore;
  final String workoutTitle;

  HangboardExerciseBloc({
                          @required this.firestore,
                          this.workoutTitle,
                        });

  @override
  HangboardExerciseState get initialState => HangboardExerciseLoading();

  @override
  Stream<HangboardExerciseState> mapEventToState(
      HangboardExerciseEvent event) async* {
    /* switch (event.runtimeType) {
      case LoadHangboardExercise:
        yield* _mapLoadHangboardExerciseToState(event);
    }*/
    if(event is LoadHangboardExercise) {
      yield* _mapLoadHangboardExerciseToState(event);
    } else if(event is AddHangboardExercise) {
      yield* _mapAddHangboardExerciseToState(event);
    } else if(event is DeleteHangboardExercise) {
      yield* _mapDeleteHangboardExerciseToState(event);
    } else if(event is UpdateHangboardExercise) {
      yield* _mapUpdateHangboardExerciseToState(event);
    } else if(event is ClearHangboardExercisePreferences) {
      yield* _mapClearHangboardExercisePreferencesToState(event);
    } else if(event is IncreaseNumberOfHangsButtonPressed) {
      yield* _mapIncreaseNumberOfHangsButtonPressedToState(event);
    } else if(event is DecreaseNumberOfHangsButtonPressed) {
      yield* _mapDecreaseNumberOfHangsButtonPressedToState(event);
    } else if(event is IncreaseNumberOfSetsButtonPressed) {
      yield* _mapIncreaseNumberOfSetsButtonPressedToState(event);
    } else if(event is DecreaseNumberOfSetsButtonPressed) {
      yield* _mapDecreaseNumberOfSetsButtonPressedToState(event);
    } else if(event is ForwardComplete) {
      yield* _mapForwardCompletedToState(event);
    } else if(event is ReverseComplete) {
      yield* _mapReverseCompletedToState(event);
    } else if(event is RepButtonPressed) {
      yield* _mapRepButtonPressedToState(event);
    } else if(event is RestButtonPressed) {
      yield* _mapRestButtonPressedToState(event);
    }
  }

  //TODO: do i even need this? seems like I could just pass the exercise to the hbpage instead
  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState(
      LoadHangboardExercise event) async* {
    try {
      yield HangboardExerciseLoaded(event.hangboardExercise);
    } catch(_) {
      yield HangboardExerciseNotLoaded();
    }
  }

  Stream<HangboardExerciseState> _mapAddHangboardExerciseToState(event) async* {
    yield null;
  }

  Stream<HangboardExerciseState> _mapDeleteHangboardExerciseToState(
      event) async* {
    yield null;
  }

  Stream<HangboardExerciseState> _mapUpdateHangboardExerciseToState(
      event) async* {
    yield null;
  }

/*
  Stream<HangboardExerciseState> _mapHangboardExerciseCompleteToState(event) {
    return null;
  }*/
//todo: left off here 7/14 -> still working my way up, think i may be done with hbpage(???)
  //todo; maybe looking to go through workout level now
  //todo: go through timer and work up to double check though
  Stream<HangboardExerciseState> _mapClearHangboardExercisePreferencesToState(
      event) async* {
    yield null;
  }

  Stream<HangboardExerciseState> _mapIncreaseNumberOfHangsButtonPressedToState(
      IncreaseNumberOfHangsButtonPressed event) async* {
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: event.exercise.hangsPerSet + 1));
  }

  Stream<HangboardExerciseState> _mapDecreaseNumberOfHangsButtonPressedToState(
      DecreaseNumberOfHangsButtonPressed event) async* {
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: event.exercise.hangsPerSet - 1));
  }

  Stream<HangboardExerciseState> _mapIncreaseNumberOfSetsButtonPressedToState(
      IncreaseNumberOfSetsButtonPressed event) async* {
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: event.exercise.numberOfSets + 1));
  }

  Stream<HangboardExerciseState> _mapDecreaseNumberOfSetsButtonPressedToState(
      DecreaseNumberOfSetsButtonPressed event) async* {
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(hangsPerSet: event.exercise.numberOfSets - 1));
  }

  Stream<HangboardExerciseState> _mapRepButtonPressedToState(
      RepButtonPressed event) {
    return null;
  }

  Stream<HangboardExerciseState> _mapRestButtonPressedToState(
      RestButtonPressed event) async* {
    yield HangboardExerciseLoaded(event.exercise);
  }

  Stream<HangboardExerciseState> _mapForwardCompletedToState(
      ForwardComplete event) async* {
    var reps = event.exercise.hangsPerSet;
    var sets = event.exercise.numberOfSets;

    /// Rest timer completing
    if(event.timer.duration == event.exercise.restDuration) {
      if(reps > 0) {
        yield HangboardExerciseLoaded(event.exercise
            .copyWith(hangsPerSet: event.exercise.hangsPerSet - 1));
        event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise));
      } else {
        event.timerBloc.dispatch(ReplaceWithBreakTimer(event.exercise));
      }
    } else {
      /// Break timer completing
      if(sets > 0) {
        yield HangboardExerciseLoaded(event.exercise
            .copyWith(hangsPerSet: event.exercise.hangsPerSet - 1));
        event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise));
      } else {
        /// Exercise is done - notification listener should pick that up and I don't need to do anything?
        yield null; // todo: - will this work?
      }
    }
    yield null;
  }

  Stream<HangboardExerciseState> _mapReverseCompletedToState(
      ReverseComplete event) async* {
    /// Rep timer completing always results in restTimer
    yield HangboardExerciseLoaded(event.exercise);
    event.timerBloc.dispatch(ReplaceWithRestTimer(event.exercise));
  }
}
