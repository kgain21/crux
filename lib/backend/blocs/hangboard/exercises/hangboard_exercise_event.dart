import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseEvent extends Equatable {
  HangboardExerciseEvent([List props = const []]) : super(props);
}

class LoadHangboardExercise extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  LoadHangboardExercise(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'LoadHangboardExercise { hangboardExercise: $hangboardExercise }';
}

class AddHangboardExercise extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  AddHangboardExercise(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'AddHangboardExercise { hangboardExercise: $hangboardExercise }';
}

class UpdateHangboardExercise extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  UpdateHangboardExercise(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'UpdateHangboardExercise { hangboardExercise: $hangboardExercise }';
}

class DeleteHangboardExercise extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  DeleteHangboardExercise(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'DeleteHangboardExercise { hangboardExercise: $hangboardExercise }';
}

class HangboardExerciseComplete extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseComplete(this.hangboardExercise)
      : super([hangboardExercise]);

  @override
  String toString() =>
      'HangboardExerciseComplete { hangboardExercise: $hangboardExercise }';
}

class ExerciseDispose extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  ExerciseDispose(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'HangboardExerciseDispose { hangboardExercise: $hangboardExercise }';
}

class ClearHangboardExercisePreferences extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  ClearHangboardExercisePreferences(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'ClearHangboardExercisePreferences { exercise: $exercise }';
}
