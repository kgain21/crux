import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';

class HangboardWorkoutBloc
    extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;
  HangboardWorkout _hangboardWorkout;

  HangboardWorkoutBloc(this.hangboardWorkoutsRepository);

  @override
  HangboardWorkoutState get initialState => HangboardWorkoutLoading();

  @override
  void dispose() {}

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if (event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState(event);
    } else if (event is AddHangboardWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteHangboardWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is ReloadHangboardWorkout) {
      yield* _mapReloadHangboardWorkoutToState(event);
    } else if (event is DeleteHangboardExercise) {
      yield* _mapDeleteHangboardExerciseToState(event);
    } else if (event is ExerciseTileLongPressed) {
      yield* _mapExerciseTileLongPressedToState(event);
    } else if (event is ExerciseTileTapped) {
      yield* _mapExerciseTileTappedToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapLoadWorkoutToState(
      LoadHangboardWorkout event) async* {
    try {
      _hangboardWorkout = HangboardWorkout.fromEntity(
          await hangboardWorkoutsRepository
              .getWorkoutByWorkoutTitle(event.workoutTitle));

      yield HangboardWorkoutLoaded(_hangboardWorkout);
    } catch (_) {
      yield HangboardWorkoutNotLoaded();
    }
  }

  Stream<HangboardWorkoutState> _mapAddWorkoutToState(event) {
    return null;
  }

  Stream<HangboardWorkoutState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<HangboardWorkoutState> _mapReloadHangboardWorkoutToState(
      ReloadHangboardWorkout event) async* {
    _hangboardWorkout = event.hangboardWorkout;
    yield HangboardWorkoutLoaded(event.hangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapDeleteHangboardExerciseToState(
      DeleteHangboardExercise event) async* {
    var updatedHangboardWorkout = await hangboardWorkoutsRepository
        .deleteExerciseFromWorkout(
        _hangboardWorkout.workoutTitle, event.hangboardExercise)
        .then((hangboardWorkout) {
      if(hangboardWorkout == null) {
        return _hangboardWorkout;
      } else {
        _hangboardWorkout = hangboardWorkout;
        return hangboardWorkout;
      }
    }).catchError((error) {
      return _hangboardWorkout;
    });

//    yield HangboardWorkoutLoaded(updatedHangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapExerciseTileLongPressedToState(
      ExerciseTileLongPressed event) async* {
    yield EditingHangboardWorkout(event.hangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapExerciseTileTappedToState(
      ExerciseTileTapped event) async* {
    yield HangboardWorkoutLoaded(event.hangboardWorkout);
  }
}
