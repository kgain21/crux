import 'package:bloc/bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouttile/hangboard_workout_tile_event.dart';
import 'package:crux/backend/blocs/hangboard/workouttile/hangboard_workout_tile_state.dart';

class HangboardWorkoutTileBloc
    extends Bloc<HangboardWorkoutTileEvent, HangboardWorkoutTileState> {
  @override
  HangboardWorkoutTileState get initialState =>
      HangboardWorkoutTileState(isEditing: false);

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
    yield null;
  }

  Stream<HangboardWorkoutTileState> _mapExerciseTileLongPressed(event) async* {
    yield currentState.update(isEditing: true);
  }

  Stream<HangboardWorkoutTileState> _mapHangboardWorkoutTileTapped(
      event) async* {
    yield currentState.update(isEditing: false);
  }
}
