import 'package:bloc/bloc.dart';
import 'package:crux/backend/bloc/hangboard/workouttile/hangboard_workout_tile_event.dart';
import 'package:crux/backend/bloc/hangboard/workouttile/hangboard_workout_tile_state.dart';

class HangboardWorkoutTileBloc
    extends Bloc<HangboardWorkoutTileEvent, HangboardWorkoutTileState> {
  @override
  HangboardWorkoutTileState get initialState =>
      HangboardWorkoutTileState(isEditing: false);

  @override
  Stream<HangboardWorkoutTileState> mapEventToState(
      HangboardWorkoutTileEvent event) async* {
    if (event is HangboardWorkoutTileDeleteButtonTapped) {
      yield* _mapHangboardWorkoutTileDeleteButtonTapped(event);
    } else if (event is HangboardWorkoutTileLongPressed) {
      yield* _mapHangboardWorkoutTileLongPressed(event);
    } else if (event is HangboardWorkoutTileTapped) {
      yield* _mapHangboardWorkoutTileTapped(event);
    }
  }

  Stream<HangboardWorkoutTileState> _mapHangboardWorkoutTileDeleteButtonTapped(
      event) async* {
    yield null;
  }

  Stream<HangboardWorkoutTileState> _mapHangboardWorkoutTileLongPressed(
      event) async* {
    yield state.update(isEditing: true);
  }

  Stream<HangboardWorkoutTileState> _mapHangboardWorkoutTileTapped(
      event) async* {
    yield state.update(isEditing: false);
  }
}
