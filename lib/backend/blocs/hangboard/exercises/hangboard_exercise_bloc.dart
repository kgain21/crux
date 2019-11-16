import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/blocs/timer/timer_event.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardExerciseBloc
    extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
  final FirestoreHangboardWorkoutsRepository firestore;
  final HangboardExercise hangboardExercise;

  HangboardExerciseBloc({
                          @required this.firestore,
                          this.hangboardExercise,
                        });

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
        event.exercise.copyWith(numberOfSets: event.exercise.numberOfSets + 1));
  }

  Stream<HangboardExerciseState> _mapDecreaseNumberOfSetsButtonPressedToState(
      DecreaseNumberOfSetsButtonPressed event) async* {
    yield HangboardExerciseLoaded(
        event.exercise.copyWith(numberOfSets: event.exercise.numberOfSets - 1));
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
        event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, true));
      } else {
        event.timerBloc.dispatch(ReplaceWithBreakTimer(event.exercise, true));
      }
    } else {
      /// Break timer completing
      if(sets > 0) {
        yield HangboardExerciseLoaded(event.exercise
            .copyWith(hangsPerSet: event.exercise.hangsPerSet - 1));
        event.timerBloc.dispatch(ReplaceWithRepTimer(event.exercise, true));
      } else {
        /// Exercise is done - notification listener should pick that up and I don't need to do anything?
        yield null; // todo: - will this work?
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
