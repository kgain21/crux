import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutEvent extends Equatable {
  HangboardWorkoutEvent([List props = const []]) : super(props);
}

class LoadHangboardWorkout extends HangboardWorkoutEvent {
  final String workoutTitle;

  LoadHangboardWorkout({this.workoutTitle})
      : super([workoutTitle]); //todo add extra shit
  @override
  String toString() => 'LoadHangboardWorkout';
}

class HangboardWorkoutAdded extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutAdded(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'AddHangboardWorkout { hangboardWorkout: $hangboardWorkout }';
}

class HangboardWorkoutUpdated extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutUpdated(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() => 'UpdateWorkout { hangboardWorkout: $hangboardWorkout }';
}

class DeleteWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  DeleteWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() => 'DeleteWorkout { hangboardWorkout: $hangboardWorkout }';
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

class ExerciseTileLongPress extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ExerciseTileLongPress(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ExerciseTileLongPress { hangboardWorkout: $hangboardWorkout }';
}
