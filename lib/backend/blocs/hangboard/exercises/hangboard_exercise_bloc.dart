import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_event.dart';
import 'package:crux/backend/blocs/hangboard/exercises/hangboard_exercise_state.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardExerciseBloc
    extends Bloc<HangboardExerciseEvent, HangboardExerciseState> {
  final FirestoreHangboardWorkoutsRepository firestore;
  final String workoutTitle;

  HangboardExerciseBloc({
                          @required this.firestore,
                          this.workoutTitle,
                        });

  @override
  HangboardExerciseState get initialState => HangboardExerciseLoading();

  @override
  Stream<HangboardExerciseState> mapEventToState(
      HangboardExerciseEvent event) async* {
    if(event is LoadHangboardExercise) {
      yield* _mapLoadHangboardExerciseToState(event);
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

  //TODO: do i even need this? seems like I could just pass the exercise to the hbpage instead
  Stream<HangboardExerciseState> _mapLoadHangboardExerciseToState(
      LoadHangboardExercise event) async* {
    try {
      yield HangboardExerciseLoaded(event.hangboardExercise);
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
