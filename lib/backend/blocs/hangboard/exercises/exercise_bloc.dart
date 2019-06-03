import 'package:bloc/bloc.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:meta/meta.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final Preferences preferences;
  final FirestoreHangboardWorkoutsRepository firestore;

  ExerciseBloc({@required this.preferences, @required this.firestore});

  @override
  ExerciseState get initialState => ExerciseLoading();

  @override
  Stream<ExerciseState> mapEventToState(ExerciseEvent event) async* {
    if (event is LoadExercise) {
      yield* _mapLoadExerciseToState();
    } else if (event is AddExercise) {
      yield* _mapAddExerciseToState(event);
    } else if (event is DeleteExercise) {
      yield* _mapDeleteExerciseToState(event);
    } else if (event is UpdateExercise) {
      yield* _mapUpdateExerciseToState(event);
    } else if (event is ExerciseComplete) {
      yield* _mapExerciseCompleteToState(event);
    } else if (event is ExerciseDispose) {
      yield* _mapExerciseDisposeToState(event);
    } else if (event is ClearExercisePreferences) {
      yield* _mapClearExercisePreferencesToState(event);
    }
  }

  Stream<ExerciseState> _mapLoadExerciseToState() async* {
    try {
      final timer = firestore.exercises(workoutPath);
      yield ExerciseLoaded();
    } catch (_) {
      yield ExerciseNotLoaded();
    }
  }

  Stream<ExerciseState> _mapAddExerciseToState(event) {
    return null;
  }

  Stream<ExerciseState> _mapDeleteExerciseToState(event) {
    return null;
  }

  Stream<ExerciseState> _mapUpdateExerciseToState(event) {
    return null;
  }

  Stream<ExerciseState> _mapExerciseCompleteToState(event) {
    return null;
  }

  Stream<ExerciseState> _mapExerciseDisposeToState(event) {
    return null;
  }

  Stream<ExerciseState> _mapClearExercisePreferencesToState(event) {
    return null;
  }
}
