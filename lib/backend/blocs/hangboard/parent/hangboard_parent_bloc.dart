import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_event.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardParentBloc
    extends Bloc<HangboardParentEvent, HangboardParentState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  HangboardParentBloc({@required this.hangboardWorkoutsRepository});

  @override
  HangboardParentState get initialState => HangboardParentLoading();

  @override
  void onEvent(HangboardParentEvent event) {
    print('HangboardParentBloc Event');
    super.onEvent(event);
  }

  @override
  Stream<HangboardParentState> mapEventToState(
      HangboardParentEvent event) async* {
    if (event is LoadHangboardParent) {
      yield* _mapLoadParentToState();
    } else if (event is AddWorkoutToHangboardParent) {
      yield* _mapAddWorkoutToHangboardParent(event);
    } else if (event is DeleteWorkoutFromHangboardParent) {
      yield* _mapDeleteWorkoutToState(event);
    } else if(event is HangboardParentUpdated) {
      yield* _mapUpdateHangboardParentToState(event);
    }
  }

  Stream<HangboardParentState> _mapLoadParentToState() async* {
    try {
      yield HangboardParentLoaded(HangboardParent(
          await hangboardWorkoutsRepository.getWorkoutTitles()));
    } catch (e) {
      print('Failed to load list of hangboard workouts: $e');
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapAddWorkoutToHangboardParent(
      AddWorkoutToHangboardParent event) async* {
    try {
      bool workoutAdded = await hangboardWorkoutsRepository
          .addNewWorkout(event.hangboardWorkout);

      if (!workoutAdded) {
        yield HangboardParentDuplicateWorkout(
            event.hangboardWorkout, event.hangboardParent);
      } else {
        List<String> hangboardWorkoutList =
        await hangboardWorkoutsRepository.getWorkoutTitles();

        yield HangboardParentWorkoutAdded(
            HangboardParent(hangboardWorkoutList));
      }
    } catch (e) {
      print(e);
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapDeleteWorkoutToState(
      DeleteWorkoutFromHangboardParent event) async* {
    try {
      await hangboardWorkoutsRepository
          .deleteWorkoutByTitle(event.hangboardWorkoutTitle);

      List<String> hangboardWorkoutEntityList =
      await hangboardWorkoutsRepository.getWorkoutTitles();

      yield HangboardParentWorkoutDeleted(
          HangboardParent(hangboardWorkoutEntityList));
    } catch (e) {
      print(e);
      yield HangboardParentNotLoaded(); //todo: don't think i want to load nothing - create new state
    }
  }

  Stream<HangboardParentState> _mapUpdateHangboardParentToState(
      HangboardParentUpdated event) async* {
    yield HangboardParentLoaded(event.hangboardParent);
  }
}
