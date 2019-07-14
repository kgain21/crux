import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:meta/meta.dart';

class WorkoutBloc extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {
  /*final Preferences preferences;
  final FirestoreHangboardWorkoutsRepository firestore;*/

//  WorkoutBloc({@required this.preferences, @required this.firestore});

  @override
  HangboardWorkoutState get initialState => HangboardWorkoutLoading();

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if(event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState();
    } else if (event is AddWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is UpdateWorkout) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapLoadWorkoutToState() async* {
    try {
      final workout = firestore.exercises(workoutPath);
      yield WorkoutLoaded();
    } catch (_) {
      yield WorkoutNotLoaded();
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
