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
    } else if(event is UpdateHangboardWorkout) {
      yield* _mapUpdateWorkoutToState(event);
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

  Stream<HangboardWorkoutState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
