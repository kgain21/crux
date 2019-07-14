import 'package:crux/backend/blocs/timer/timer_bloc.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer.dart';
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
/*
class HangboardExerciseComplete extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseComplete(this.hangboardExercise)
      : super([hangboardExercise]);

  @override
  String toString() =>
      'HangboardExerciseComplete { hangboardExercise: $hangboardExercise }';
}*/

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

class IncreaseNumberOfHangsButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  IncreaseNumberOfHangsButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'IncreaseNumberOfHangsButtonPressed { exercise: $exercise }';
}

class DecreaseNumberOfHangsButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  DecreaseNumberOfHangsButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'DecreaseNumberOfHangsButtonPressed { exercise: $exercise }';
}

class IncreaseNumberOfSetsButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  IncreaseNumberOfSetsButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'IncreaseNumberOfSetsButtonPressed { exercise: $exercise }';
}

class DecreaseNumberOfSetsButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  DecreaseNumberOfSetsButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'DecreaseNumberOfSetsButtonPressed { exercise: $exercise }';
}

class RepCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  RepCompleted(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'RepCompleted { exercise: $exercise }';
}

class RestCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  RestCompleted(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'RestCompleted { exercise: $exercise }';
}

class BreakCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  BreakCompleted(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'BreakCompleted { exercise: $exercise }';
}

class RepButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  RepButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'RepButtonPressed { exercise: $exercise }';
}

class RestButtonPressed extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  RestButtonPressed(this.exercise) : super([exercise]);

  @override
  String toString() =>
      'RestButtonPressed { exercise: $exercise }';
}

class ForwardComplete extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final Timer timer;
  final TimerBloc timerBloc;

  ForwardComplete(this.exercise, this.timer, this.timerBloc)
      : super([exercise, timer]);

  @override
  String toString() =>
      'ForwardComplete { exercise: $exercise, timer: $timer }';
}

class ReverseComplete extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final Timer timer;
  final TimerBloc timerBloc;

  ReverseComplete(this.exercise, this.timer, this.timerBloc)
      : super([exercise, timer]);

  @override
  String toString() =>
      'ReverseComplete { exercise: $exercise, timer: $timer }';
}




