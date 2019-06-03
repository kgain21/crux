import 'package:crux/backend/models/exercise/exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExerciseEvent extends Equatable {
  ExerciseEvent([List props = const []]) : super(props);
}

class LoadExercise extends ExerciseEvent {
  @override
  String toString() => 'LoadExercise';
}

class AddExercise extends ExerciseEvent {
  final Exercise exercise;

  AddExercise(this.exercise) : super([exercise]);

  @override
  String toString() => 'AddExercise { exercise: $exercise }';
}

class UpdateExercise extends ExerciseEvent {
  final Exercise exercise;

  UpdateExercise(this.exercise) : super([exercise]);

  @override
  String toString() => 'UpdateExercise { exercise: $exercise }';
}

class DeleteExercise extends ExerciseEvent {
  final Exercise exercise;

  DeleteExercise(this.exercise) : super([exercise]);

  @override
  String toString() => 'DeleteExercise { exercise: $exercise }';
}

class ExerciseComplete extends ExerciseEvent {
  final Exercise exercise;

  ExerciseComplete(this.exercise) : super([exercise]);

  @override
  String toString() => 'ExerciseComplete { exercise: $exercise }';
}

class ExerciseDispose extends ExerciseEvent {
  final Exercise exercise;

  ExerciseDispose(this.exercise) : super([exercise]);

  @override
  String toString() => 'ExerciseDispose { exercise: $exercise }';
}

class ClearExercisePreferences extends ExerciseEvent {
  final Exercise exercise;

  ClearExercisePreferences(this.exercise) : super([exercise]);

  @override
  String toString() => 'ClearExercisePreferences { exercise: $exercise }';
}
