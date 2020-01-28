import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutEvent extends Equatable {
  const HangboardWorkoutEvent();

  @override
  List<Object> get props => [];
}

class HangboardWorkoutLoaded extends HangboardWorkoutEvent {
  final String workoutTitle;

  HangboardWorkoutLoaded(this.workoutTitle);

  @override
  String toString() => 'HangboardWorkoutLoaded { workoutTitle: $workoutTitle }';

  @override
  List<Object> get props => [workoutTitle];
}

class HangboardWorkoutAdded extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutAdded(this.hangboardWorkout);

  @override
  String toString() =>
      'HangboardWorkoutAdded { hangboardWorkout: $hangboardWorkout }';

  @override
  List<Object> get props => [hangboardWorkout];
}

class HangboardWorkoutReloaded extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutReloaded(this.hangboardWorkout);

  @override
  String toString() =>
      'HangboardWorkoutReloaded { hangboardWorkout: $hangboardWorkout }';

  @override
  List<Object> get props => [hangboardWorkout];
}

class HangboardWorkoutDeleted extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutDeleted(this.hangboardWorkout);

  @override
  String toString() =>
      'HangboardWorkoutDeleted { hangboardWorkout: $hangboardWorkout }';

  @override
  List<Object> get props => [hangboardWorkout];
}

class HangboardWorkoutExerciseDeleted extends HangboardWorkoutEvent {
  final HangboardExercise hangboardExercise;

  HangboardWorkoutExerciseDeleted(this.hangboardExercise);

  @override
  String toString() =>
      'HangboardWorkoutExerciseDeleted { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class ExerciseTileLongPressed extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ExerciseTileLongPressed(this.hangboardWorkout);

  @override
  String toString() =>
      'ExerciseTileLongPressed { hangboardWorkout: $hangboardWorkout }';

  @override
  List<Object> get props => [hangboardWorkout];
}

class ExerciseTileTapped extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ExerciseTileTapped(this.hangboardWorkout);

  @override
  String toString() =>
      'ExerciseTileTapped { hangboardWorkout: $hangboardWorkout }';

  @override
  List<Object> get props => [hangboardWorkout];
}

/*
TODO: Not yet sure if these will be used
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

  @override
  List<Object> get props => null;
}
class DeleteButtonTapped extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  DeleteButtonTapped(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'DeleteButtonTap { hangboardWorkout: $hangboardWorkout }';
}

class ClearWorkoutPreferences extends HangboardWorkoutEvent {
  final HangboardWorkout hangboardWorkout;

  ClearWorkoutPreferences(this.hangboardWorkout) : super([hangboardWorkout]);

  @override
  String toString() =>
      'ClearWorkoutPreferences { hangboardWorkout: $hangboardWorkout }';
}
*/
