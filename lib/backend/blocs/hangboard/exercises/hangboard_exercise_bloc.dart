import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardExerciseBloc
    extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
//  final Preferences preferences;
  final FirestoreHangboardWorkoutsRepository firestore;
  final String workoutTitle;

  HangboardExerciseBloc(
      { /*@required this.preferences,*/ @required this.firestore, this.workoutTitle,});

  @override
  HangboardExerciseState get initialState => HangboardExerciseLoading();

  @override
  Stream<HangboardExerciseState> mapEventToState(
      HangboardExerciseEvent event) async* {
    if(event is LoadExercise) {
      yield* _mapLoadHangboardExerciseToState();
    } else if(event is AddHangboardExercise) {
      yield* _mapAddHangboardExerciseToState(event);
    } else if(event is DeleteHangboardExercise) {
      yield* _mapDeleteHangboardExerciseToState(event);
    } else if(event is UpdateHangboardExercise) {
      yield* _mapUpdateHangboardExerciseToState(event);
    } else if(event is HangboardExerciseComplete) {
      yield* _mapHangboardExerciseCompleteToState(event);
    } else if(event is ClearHangboardExercisePreferences) {
      yield* _mapClearHangboardExercisePreferencesToState(event);
    }
  }

  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState() async* {
    try {
      final hangboardExercise = firestore.exercises(workoutTitle);
      //todo: left off here 6/10 working on getting data from firebase and turning that into a hangboardExercise
      yield HangboardExerciseLoaded();
    } catch(_) {
      yield HangboardExerciseNotLoaded();
    }
  }

  Stream<HangboardExerciseState> _mapAddHangboardExerciseToState(event) {
    return null;
  }

  Stream<HangboardExerciseState> _mapDeleteHangboardExerciseToState(event) {
    return null;
  }

  Stream<HangboardExerciseState> _mapUpdateHangboardExerciseToState(event) {
    return null;
  }

  Stream<HangboardExerciseState> _mapHangboardExerciseCompleteToState(event) {
    return null;
  }

  Stream<HangboardExerciseState> _mapClearHangboardExercisePreferencesToState(
      event) {
    return null;
  }
}
