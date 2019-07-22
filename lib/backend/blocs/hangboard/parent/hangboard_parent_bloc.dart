import 'package:bloc/bloc.dart';

class HangboardParentBloc
    extends Bloc<HangboardParentEvent, HangboardParentState> {
  /*final Preferences preferences;
  final FirestoreHangboardWorkoutsRepository firestore;*/

//  WorkoutBloc({@required this.preferences, @required this.firestore});

  @override
  HangboardParentState get initialState => HangboardParentLoading();

  @override
  Stream<HangboardParentState> mapEventToState(
      HangboardParentEvent event) async* {
    if (event is LoadHangboardParent) {
      yield* _mapLoadWorkoutToState();
    }
  }

  Stream<HangboardParentState> _mapLoadWorkoutToState() async* {
    try {
      final workout =
          firestoreHangboardWorkoutsRepository.exercises(workoutPath);
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
