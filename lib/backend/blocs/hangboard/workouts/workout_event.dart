import 'package:crux/backend/models/workout/workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WorkoutEvent extends Equatable {
  WorkoutEvent([List props = const []]) : super(props);
}

class LoadWorkout extends WorkoutEvent {
  @override
  String toString() => 'LoadWorkout';
}

class AddWorkout extends WorkoutEvent {
  final Workout workout;

  AddWorkout(this.workout) : super([workout]);

  @override
  String toString() => 'AddWorkout { workout: $workout }';
}

class UpdateWorkout extends WorkoutEvent {
  final Workout workout;

  UpdateWorkout(this.workout) : super([workout]);

  @override
  String toString() => 'UpdateWorkout { workout: $workout }';
}

class DeleteWorkout extends WorkoutEvent {
  final Workout workout;

  DeleteWorkout(this.workout) : super([workout]);

  @override
  String toString() => 'DeleteWorkout { workout: $workout }';
}

class WorkoutComplete extends WorkoutEvent {
  final Workout workout;

  WorkoutComplete(this.workout) : super([workout]);

  @override
  String toString() => 'WorkoutComplete { workout: $workout }';
}

class WorkoutDispose extends WorkoutEvent {
  final Workout workout;

  WorkoutDispose(this.workout) : super([workout]);

  @override
  String toString() => 'WorkoutDispose { workout: $workout }';
}

class ClearWorkoutPreferences extends WorkoutEvent {
  final Workout workout;

  ClearWorkoutPreferences(this.workout) : super([workout]);

  @override
  String toString() => 'ClearWorkoutPreferences { workout: $workout }';
}
