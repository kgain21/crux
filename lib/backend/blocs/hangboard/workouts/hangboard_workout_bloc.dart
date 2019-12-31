import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
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
  Stream<HangboardWorkoutState> mapEventToState(HangboardWorkoutEvent event) async* {
    if(event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState(event);
    } else if(event is HangboardWorkoutAdded) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if(event is HangboardWorkoutUpdated) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapLoadWorkoutToState(
      LoadHangboardWorkout event) async* {
    try {
//      final exerciseList = await firestoreHangboardWorkoutsRepository
//          .getExercises(event.workoutTitle);

//      yield HangboardWorkoutLoaded(HangboardWorkout(event.workoutTitle,
//          exerciseList.map(HangboardExercise.fromEntity).toList()));
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
