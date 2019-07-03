import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutEvent extends Equatable {
  HangboardWorkoutEvent([List props = const []]) : super(props);
}

class LoadWorkout extends HangboardWorkoutEvent {
  @override
  String toString() => 'LoadWorkout';
}

class AddWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  AddWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() => 'AddWorkout { hangboardWorkout: $hangboardWorkout }';
}

class UpdateWorkout extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  UpdateWorkout(this.hangboardWorkout) : super([hangboardWorkout]);

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
