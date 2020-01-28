import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_event.dart';
import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout_list.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardWorkoutListBloc
    extends Bloc<HangboardWorkoutListEvent, HangboardWorkoutListState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  HangboardWorkoutListBloc({@required this.hangboardWorkoutsRepository});

  @override
  HangboardWorkoutListState get initialState =>
      HangboardWorkoutListLoadInProgress();

  @override
  void onEvent(HangboardWorkoutListEvent event) {
    print('HangboardWorkoutListBloc Event');
    super.onEvent(event);
  }

  @override
  Stream<HangboardWorkoutListState> mapEventToState(
      HangboardWorkoutListEvent event) async* {
    if (event is HangboardWorkoutListLoaded) {
      yield* _mapHangboardWorkoutListLoadedToState();
    } else if (event is HangboardWorkoutListWorkoutAdded) {
      yield* _mapHangboardWorkoutListWorkoutAdded(event);
    } else if (event is HangboardWorkoutListWorkoutDeleted) {
      yield* _mapDeleteWorkoutToState(event);
    }
  }

  Stream<HangboardWorkoutListState>
      _mapHangboardWorkoutListLoadedToState() async* {
    try {
      yield HangboardWorkoutListLoadSuccess(HangboardWorkoutList(
          await hangboardWorkoutsRepository.getWorkoutTitles()));
    } catch (e) {
      print('Failed to load list of hangboard workouts: $e');
      yield HangboardWorkoutListLoadFailure();
    }
  }

  Stream<HangboardWorkoutListState> _mapHangboardWorkoutListWorkoutAdded(
      HangboardWorkoutListWorkoutAdded event) async* {
    try {
      bool workoutAdded = await hangboardWorkoutsRepository
          .addNewWorkout(event.hangboardWorkout);

      if (!workoutAdded) {
        yield HangboardWorkoutListAddWorkoutDuplicate(
            event.hangboardWorkout, event.hangboardWorkoutList);
      } else {
        List<String> hangboardWorkoutList =
            await hangboardWorkoutsRepository.getWorkoutTitles();

        yield HangboardWorkoutListAddWorkoutSuccess(
            HangboardWorkoutList(hangboardWorkoutList));
      }
    } catch (e) {
      print(e);
      yield HangboardWorkoutListLoadFailure();
    }
  }

  Stream<HangboardWorkoutListState> _mapDeleteWorkoutToState(
      HangboardWorkoutListWorkoutDeleted event) async* {
    try {
      await hangboardWorkoutsRepository
          .deleteWorkoutByTitle(event.hangboardWorkoutTitle);

      List<String> hangboardWorkoutEntityList =
          await hangboardWorkoutsRepository.getWorkoutTitles();

      yield HangboardWorkoutListDeleteWorkoutSuccess(
          HangboardWorkoutList(hangboardWorkoutEntityList));
    } catch (e) {
      print(e);
      yield HangboardWorkoutListLoadFailure(); //todo: don't think i want to load nothing - create new state
    }
  }
}
