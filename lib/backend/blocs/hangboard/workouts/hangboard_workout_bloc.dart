import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';

class HangboardWorkoutBloc
    extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  HangboardWorkoutBloc(this.hangboardWorkoutsRepository);

  @override
  HangboardWorkoutState get initialState => HangboardWorkoutLoading();

  @override
  void dispose() {}

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if(event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState(event);
    } else if(event is AddHangboardWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if(event is DeleteHangboardWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if(event is ReloadHangboardWorkout) {
      yield* _mapReloadHangboardWorkoutToState(event);
    } else if(event is DeleteHangboardExercise) {
      yield* _mapHangboardExerciseToState(event);
    } else if(event is ExerciseTileLongPress) {
      yield* _mapExerciseTileLongPressToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapLoadWorkoutToState(
      LoadHangboardWorkout event) async* {
    try {
      yield HangboardWorkoutLoaded(HangboardWorkout.fromEntity(
          await hangboardWorkoutsRepository
              .getWorkoutByWorkoutTitle(event.workoutTitle)));
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
    yield HangboardWorkoutLoaded(event.hangboardWorkout);
  }

  Stream<HangboardWorkoutState> _mapHangboardExerciseToState(
      DeleteHangboardExercise event) async* {
//    hangboardWorkoutsRepository.deleteExerciseFromWorkout(event.hangboardExercise);
//todo: pass in workout, remove exercise from workout, save workout to firebase, yield workout
    yield /*HangboardWorkoutLoaded()*/ null;
  }

  Stream<HangboardWorkoutState> _mapExerciseTileLongPressToState(
      ExerciseTileLongPress event) async* {
    //todo: UPDATED: ***THIS NEEDS TO BE THE SAME STATE BUT WITH A FLAG INSTEAD***
    //todo: need to pass down state in builder, cant do that if I have two different states, hence it has to be a flag
    yield EditingHangboardWorkout(event.hangboardWorkout);
  }
}
