import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class NewExerciseFormState extends Equatable {
  NewExerciseFormState([List props = const []]) : super(props);
}

class NewExerciseFormInitialState extends NewExerciseFormState {
  @override
  String toString() => 'NewExerciseFormInitialState';
}

class HangboardParentLoaded extends NewExerciseFormState {
  final HangboardParent hangboardParent;

  HangboardParentLoaded(
    this.hangboardParent,
  ) : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentLoaded: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}

class HangboardParentNotLoaded extends NewExerciseFormState {
  @override
  String toString() => 'HangboardParentNotLoaded';
}

class HangboardParentDuplicateWorkout extends NewExerciseFormState {
  final HangboardWorkout hangboardWorkout;
  final HangboardParent hangboardParent;

  HangboardParentDuplicateWorkout(
    this.hangboardWorkout,
    this.hangboardParent,
  ) : super([hangboardWorkout, hangboardParent]);

  @override
  String toString() => 'HangboardParentDuplicateWorkout';
}

class HangboardParentWorkoutAdded extends NewExerciseFormState {
  final HangboardParent hangboardParent;

  HangboardParentWorkoutAdded(
    this.hangboardParent,
  ) : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentWorkoutAdded: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}

class HangboardParentWorkoutDeleted extends NewExerciseFormState {
  final HangboardParent hangboardParent;

  HangboardParentWorkoutDeleted(
    this.hangboardParent,
  ) : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentWorkoutDeleted: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}
