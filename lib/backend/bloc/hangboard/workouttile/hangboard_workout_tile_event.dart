import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutTileEvent extends Equatable {
  HangboardWorkoutTileEvent();
}

class HangboardWorkoutTileTapped extends HangboardWorkoutTileEvent {
  final bool isEditing;

  HangboardWorkoutTileTapped(this.isEditing);

  @override
  String toString() => 'HangboardWorkoutTileTapped { isEditing: $isEditing }';

  @override
  List<Object> get props => [isEditing];
}

class HangboardWorkoutTileDeleteButtonTapped extends HangboardWorkoutTileEvent {
  final bool isEditing;

  HangboardWorkoutTileDeleteButtonTapped(this.isEditing);

  @override
  String toString() =>
      'HangboardWorkoutTileDeleteButtonTapped { isEditing: $isEditing }';

  @override
  List<Object> get props => [isEditing];
}

class HangboardWorkoutTileLongPressed extends HangboardWorkoutTileEvent {
  final bool isEditing;

  HangboardWorkoutTileLongPressed(this.isEditing);

  @override
  String toString() =>
      'HangboardWorkoutTileLongPressed { isEditing: $isEditing }';

  @override
  List<Object> get props => [isEditing];
}
