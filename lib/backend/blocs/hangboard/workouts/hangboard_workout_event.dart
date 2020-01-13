import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutEvent extends Equatable {
  HangboardWorkoutEvent([List props = const []]) : super(props);
}

class LoadHangboardWorkout extends HangboardWorkoutEvent {
  final String workoutTitle;

  LoadHangboardWorkout(this.workoutTitle)
      : super([workoutTitle]);

  @override
  String toString() => 'LoadHangboardWorkout';
}

class AddHangboardWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  AddHangboardWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'AddHangboardWorkout { hangboardWorkout: $hangboardWorkout }';
}

class ReloadHangboardWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ReloadHangboardWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ReloadHangboardWorkout { hangboardWorkout: $hangboardWorkout }';
}

class DeleteHangboardWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  DeleteHangboardWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'DeleteHangboardWorkout { hangboardWorkout: $hangboardWorkout }';
}

class DeleteHangboardExercise extends HangboardWorkoutEvent {
  final HangboardExercise hangboardExercise;

  DeleteHangboardExercise(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'DeleteHangboardExercise { hangboardExercise: $hangboardExercise }';
}

class WorkoutComplete extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  WorkoutComplete(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'WorkoutComplete { hangboardWorkout: $hangboardWorkout }';
}

class WorkoutDispose extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  WorkoutDispose(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() => 'WorkoutDispose { hangboardWorkout: $hangboardWorkout }';
}

class ClearWorkoutPreferences extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ClearWorkoutPreferences(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ClearWorkoutPreferences { hangboardWorkout: $hangboardWorkout }';
}

class DeleteButtonTap extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  DeleteButtonTap(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'DeleteButtonTap { hangboardWorkout: $hangboardWorkout }';
}

class ExerciseTileLongPressed extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ExerciseTileLongPressed(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ExerciseTileLongPressed { hangboardWorkout: $hangboardWorkout }';
}

class ExerciseTileTapped extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ExerciseTileTapped(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ExerciseTileTapped { hangboardWorkout: $hangboardWorkout }';
}
