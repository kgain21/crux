import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutTileState extends Equatable {
  final bool isEditing;

  HangboardWorkoutTileState(this.isEditing, [List props = const []])
      : super(props);
}

class HangboardWorkoutTileInitial extends HangboardWorkoutTileState {
  final bool isEditing;

  HangboardWorkoutTileInitial(this.isEditing) : super(isEditing, [isEditing]);

  @override
  String toString() {
    return 'HangboardWorkoutTileInitial: {'
        'isEditing: ${isEditing.toString()} }';
  }
}

class HangboardWorkoutTileEditing extends HangboardWorkoutTileState {
  final bool isEditing;

  HangboardWorkoutTileEditing(this.isEditing) : super(isEditing, [isEditing]);

  @override
  String toString() => 'HangboardWorkoutTileEditing';
}
