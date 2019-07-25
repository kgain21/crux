import 'package:bloc/bloc.dart';
import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

import 'hangboard_parent_event.dart';
import 'hangboard_parent_state.dart';

class HangboardParentBloc
    extends Bloc<HangboardParentEvent, HangboardParentState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  HangboardParentBloc({@required this.hangboardWorkoutsRepository});

  @override
  HangboardParentState get initialState => HangboardParentLoading();

  @override
  Stream<HangboardParentState> mapEventToState(
      HangboardParentEvent event) async* {
    if (event is LoadHangboardParent) {
      yield* _mapLoadParentToState();
    }
  }

  Stream<HangboardParentState> _mapLoadParentToState() async* {
    try {
      final List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
      await hangboardWorkoutsRepository.getWorkouts();

      //todo: left off here - 7/24: think I got the mapping down. Had to change from
      //todo: stream to future but don't know if it matters, I was just going to take the .first
      //todo: anyways. Should look at the getExercises() usage as well and do the same there.
      yield HangboardParentLoaded(HangboardParent(hangboardWorkoutEntityList
          .map(HangboardWorkout.fromEntity)
          .toList()));
    } catch (_) {
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapAddWorkoutToState(event) {
    return null;
  }

  Stream<HangboardParentState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<HangboardParentState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
