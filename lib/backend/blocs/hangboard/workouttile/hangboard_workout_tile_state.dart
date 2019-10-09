import 'package:meta/meta.dart';

@immutable
class HangboardWorkoutTileState {
  final bool isEditing;

  HangboardWorkoutTileState({@required this.isEditing});

  HangboardWorkoutTileState update({bool isEditing}) {
    return copyWith(isEditing: isEditing);
  }

  HangboardWorkoutTileState copyWith({bool isEditing}) {
    return HangboardWorkoutTileState(
      isEditing: isEditing ?? this.isEditing,
    );
  }

  @override
  String toString() {
    return '''LoginState {
      isEditing: $isEditing
    }''';
  }
}
/*
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
}*/
