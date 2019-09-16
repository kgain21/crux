import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutTileEvent extends Equatable {
  HangboardWorkoutTileEvent([List props = const []]) : super(props);
}

class HangboardWorkoutTileTapped extends HangboardWorkoutTileEvent {
  final bool isEditing;

  HangboardWorkoutTileTapped(this.isEditing) : super([isEditing]);

  @override
  String toString() => 'HangboardWorkoutTileTapped { isEditing: $isEditing }';
}

class DeleteButtonTapped extends HangboardWorkoutTileEvent {
  final bool isEditing;

  DeleteButtonTapped(this.isEditing) : super([isEditing]);

  @override
  String toString() => 'DeleteButtonTapped { isEditing: $isEditing }';
}

class HangboardWorkoutTileLongPressed extends HangboardWorkoutTileEvent {
  final bool isEditing;

  HangboardWorkoutTileLongPressed(this.isEditing) : super([isEditing]);

  @override
  String toString() =>
      'HangboardWorkoutTileLongPressed { isEditing: $isEditing }';
}
