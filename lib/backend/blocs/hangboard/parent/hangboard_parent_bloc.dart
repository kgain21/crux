import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_event.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:meta/meta.dart';

class HangboardParentBloc
    extends Bloc<HangboardParentEvent, HangboardParentState> {
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  HangboardParentBloc({@required this.hangboardWorkoutsRepository});

  @override
  HangboardParentState get initialState => HangboardParentLoading();

  @override
  Stream<HangboardParentState> mapEventToState(
      HangboardParentEvent event) async* {
    if (event is LoadHangboardParent) {
      yield* _mapLoadParentToState();
    } else if(event is AddWorkoutToHangboardParent) {
      yield* _mapAddWorkoutToHangboardParent(event);
    } else if(event is DeleteWorkoutFromHangboardParent) {
      yield* _mapDeleteWorkoutToState(event);
    }
  }

  Stream<HangboardParentState> _mapLoadParentToState() async* {
    try {
      List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
      await hangboardWorkoutsRepository.getWorkouts();

      yield HangboardParentLoaded(HangboardParent(hangboardWorkoutEntityList
          .map(HangboardWorkout.fromEntity)
          .toList()));
    } catch(e) {
      print(e);
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapAddWorkoutToHangboardParent(
      AddWorkoutToHangboardParent event) async* {
    try {
      bool workoutAdded = await hangboardWorkoutsRepository
          .addNewWorkout(event.hangboardWorkout);

      if(!workoutAdded) {
        yield HangboardParentDuplicateWorkout(
            event.hangboardWorkout, event.hangboardParent);
      } else {
        List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
        await hangboardWorkoutsRepository.getWorkouts();

        yield HangboardParentWorkoutAdded(HangboardParent(
            hangboardWorkoutEntityList
                .map(HangboardWorkout.fromEntity)
                .toList()));
      }
    } catch(e) {
      print(e);
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapAddWorkoutToState(AddHangboardParent event) {
    return null;
  }

  Stream<HangboardParentState> _mapDeleteWorkoutToState(
      DeleteWorkoutFromHangboardParent event) async* {
    try {
      await hangboardWorkoutsRepository.deleteWorkout(event.hangboardWorkout);

      List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
      await hangboardWorkoutsRepository.getWorkouts();

      yield HangboardParentWorkoutDeleted(HangboardParent(
          hangboardWorkoutEntityList
              .map(HangboardWorkout.fromEntity)
              .toList()));
    } catch(e) {
      print(e);
      yield HangboardParentNotLoaded(); //todo: don't think i want to load nothing - create new state
    }
  }

  Stream<HangboardParentState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
