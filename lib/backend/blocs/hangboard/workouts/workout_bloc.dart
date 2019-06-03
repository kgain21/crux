import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:meta/meta.dart';

class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final Preferences preferences;
  final FirestoreHangboardWorkoutsRepository firestore;

  WorkoutBloc({@required this.preferences, @required this.firestore});

  @override
  WorkoutState get initialState => WorkoutLoading();

  @override
  Stream<WorkoutState> mapEventToState(WorkoutEvent event) async* {
    if (event is LoadWorkout) {
      yield* _mapLoadWorkoutToState();
    } else if (event is AddWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is UpdateWorkout) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  Stream<WorkoutState> _mapLoadWorkoutToState() async* {
    try {
      final workout = firestore.exercises(workoutPath);
      yield WorkoutLoaded();
    } catch (_) {
      yield WorkoutNotLoaded();
    }
  }

  Stream<WorkoutState> _mapAddWorkoutToState(event) {
    return null;
  }

  Stream<WorkoutState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<WorkoutState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
