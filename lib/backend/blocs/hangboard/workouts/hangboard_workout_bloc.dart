import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class WorkoutBloc extends Bloc<HangboardWorkoutEvent, HangboardWorkoutState> {
  /*final Preferences preferences;*/
  final FirestoreHangboardWorkoutsRepository firestoreHangboardWorkoutsRepository;

  WorkoutBloc({@required this.firestoreHangboardWorkoutsRepository});

  @override
  HangboardWorkoutState get initialState => HangboardWorkoutLoading();

  @override
  Stream<HangboardWorkoutState> mapEventToState(
      HangboardWorkoutEvent event) async* {
    if(event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState();
    } else if(event is AddHangboardWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is UpdateWorkout) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  //todo: left off here 7/22 - lots to do with workouts/parent. Trying to figure out
  //todo: the stream of exercises turning into workout below. Not sure if that's the right way to do it
  Stream<HangboardWorkoutState> _mapLoadWorkoutToState() async* {
    try {
      final exerciseList = firestoreHangboardWorkoutsRepository.getExercises(
          workoutTitle);
      final hangboardWorkout = HangboardWorkout(workoutTitle, exerciseList);
      yield HangboardWorkoutLoaded(hangboardWorkout);
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
