import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutState extends Equatable {
  HangboardWorkoutState();
}

class HangboardWorkoutLoadInProgress extends HangboardWorkoutState {
  @override
  String toString() => 'HangboardWorkoutLoadInProgress';

  @override
  List<Object> get props => [];
}

class HangboardWorkoutLoadSuccess extends HangboardWorkoutState {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutLoadSuccess(this.hangboardWorkout);

  @override
  String toString() {
    return 'HangboardWorkoutLoadSuccess: { '
        'hangboardWorkout: ${hangboardWorkout.toString()}'
        '}';
  }

  @override
  List<Object> get props => [hangboardWorkout];
}

class HangboardWorkoutEditInProgress extends HangboardWorkoutState {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutEditInProgress(this.hangboardWorkout);

  @override
  String toString() {
    return 'HangboardWorkoutEditInProgress: {'
        'hangboardWorkout: ${hangboardWorkout.toString()}'
        '}';
  }

  @override
  List<Object> get props => [hangboardWorkout];
}

class HangboardWorkoutLoadFailure extends HangboardWorkoutState {
  @override
  String toString() => 'HangboardWorkoutLoadFailure';

  @override
  List<Object> get props => [];
}
