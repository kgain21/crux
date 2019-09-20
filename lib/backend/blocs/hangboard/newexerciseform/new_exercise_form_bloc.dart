import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/newexerciseform/new_exercise_form_event.dart';
import 'package:crux/backend/blocs/hangboard/newexerciseform/new_exercise_form_state.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class NewExerciseFormBloc
    extends Bloc<NewExerciseFormEvent, NewExerciseFormState> {
  final FirestoreHangboardWorkoutsRepository
      firestoreHangboardWorkoutsRepository;

  NewExerciseFormBloc({@required this.firestoreHangboardWorkoutsRepository});

  @override
  NewExerciseFormState get initialState => NewExerciseFormInitialState();

  @override
  Stream<NewExerciseFormState> mapEventToState(
      NewExerciseFormEvent event) async* {
    if (event is LoadHangboardWorkout) {
      yield* _mapLoadWorkoutToState(event);
    } else if (event is AddHangboardWorkout) {
      yield* _mapAddWorkoutToState(event);
    } else if (event is DeleteWorkout) {
      yield* _mapDeleteWorkoutToState(event);
    } else if (event is UpdateWorkout) {
      yield* _mapUpdateWorkoutToState(event);
    }
  }

  Stream<NewExerciseFormState> _mapLoadWorkoutToState(
      NewExerciseFormEvent event) async* {
    try {
//      final exerciseList = await firestoreHangboardWorkoutsRepository
//          .getExercises(event.workoutTitle);

//      yield HangboardWorkoutLoaded(HangboardWorkout(event.workoutTitle,
//          exerciseList.map(HangboardExercise.fromEntity).toList()));
    } catch (_) {
//      yield HangboardWorkoutNotLoaded();
    }
  }

  Stream<NewExerciseFormState> _mapAddWorkoutToState(event) {
    return null;
  }

  Stream<NewExerciseFormState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<NewExerciseFormState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
