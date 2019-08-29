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
    }
    if(event is UpdateHangboardParent) {
      yield* _mapUpdateParentToState(event);
    }
  }

  Stream<HangboardParentState> _mapLoadParentToState() async* {
    try {
      List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
      await hangboardWorkoutsRepository.getWorkouts();

      yield HangboardParentLoaded(HangboardParent(hangboardWorkoutEntityList
          .map(HangboardWorkout.fromEntity)
          .toList())
      );
    } catch (_) {
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapUpdateParentToState(
      UpdateHangboardParent event) async* {
    try {
      bool workoutAdded = await hangboardWorkoutsRepository.addNewWorkout(
          event.hangboardWorkout);

      if(!workoutAdded) {
        //todo: left off here 8/29
        yield HangboardParentDuplicateWorkout(
            event.hangboardWorkout, event.hangboardWorkout);
      } else {
        List<HangboardWorkoutEntity> hangboardWorkoutEntityList =
        await hangboardWorkoutsRepository.getWorkouts();

        yield HangboardParentWorkoutAdded(
            HangboardParent(hangboardWorkoutEntityList
                .map(HangboardWorkout.fromEntity)
                .toList())
        );
      }
    } catch(_) {
      yield HangboardParentNotLoaded();
    }
  }

  Stream<HangboardParentState> _mapAddWorkoutToState(AddHangboardParent event) {
    //todo: 8/27 need to add one new workout to the list, should i just use the addWorkout method?
    //todo: or update parent? still need to figure out.
    return null;
  }

  Stream<HangboardParentState> _mapDeleteWorkoutToState(event) {
    return null;
  }

  Stream<HangboardParentState> _mapUpdateWorkoutToState(event) {
    return null;
  }
}
