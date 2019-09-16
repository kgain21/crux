import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class WorkoutBloc extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {

  final FirestoreHangboardWorkoutsRepository
  firestoreHangboardWorkoutsRepository;

  WorkoutBloc({@required this.firestoreHangboardWorkoutsRepository});

  @override
  HangboardWorkoutState get initialState => HangboardWorkoutLoading();

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if(event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState(event);
    } else if(event is AddHangboardWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is UpdateWorkout) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  Stream<HangboardWorkoutState> _mapLoadWorkoutToState(
      LoadHangboardWorkout event) async* {
    try {
      final exerciseList = await firestoreHangboardWorkoutsRepository
          .getExercises(event.workoutTitle);

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

