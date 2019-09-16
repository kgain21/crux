import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouttile/hangboard_workout_tile_event.dart';
import 'package:crux/backend/blocs/hangboard/workouttile/hangboard_workout_tile_state.dart';

class HangboardWorkoutTileBloc
    extends Bloc<HangboardWorkoutTileEvent, HangboardWorkoutTileState> {
  @override
  HangboardWorkoutTileState get initialState =>
      HangboardWorkoutTileInitial(false);

  @override
  Stream<HangboardWorkoutTileState> mapEventToState(
      HangboardWorkoutTileEvent event) async* {
    if (event is DeleteButtonTapped) {
      yield* _mapDeleteButtonTapped(event);
    } else if (event is HangboardWorkoutTileLongPressed) {
      yield* _mapExerciseTileLongPressed(event);
    } else if (event is HangboardWorkoutTileTapped) {
      yield* _mapHangboardWorkoutTileTapped(event);
    }
  }

  Stream<HangboardWorkoutTileState> _mapDeleteButtonTapped(event) async* {
    //dispatch to workout delete from tile ui directly
//    workoutBloc.dispatch(event)
    yield null; /*HangboardWorkoutTileInitial(false);*/
  }

  Stream<HangboardWorkoutTileState> _mapExerciseTileLongPressed(event) async* {
    yield HangboardWorkoutTileEditing(true);
  }

  Stream<HangboardWorkoutTileState> _mapHangboardWorkoutTileTapped(
      event) async* {
    yield HangboardWorkoutTileInitial(false);
  }
}
