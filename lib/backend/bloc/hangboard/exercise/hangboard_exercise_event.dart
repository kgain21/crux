import 'package:crux/backend/bloc/timer/timer_bloc.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseEvent extends Equatable {
  HangboardExerciseEvent();
}

class HangboardExerciseLoaded extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseLoaded(this.hangboardExercise);

  @override
  String toString() =>
      'HangboardExerciseLoaded { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseAdded extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseAdded(this.hangboardExercise);

  @override
  String toString() =>
      'HangboardExerciseAdded { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseUpdated extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseUpdated(this.hangboardExercise);

  @override
  String toString() =>
      'HangboardExerciseUpdated { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseDisposed extends HangboardExerciseEvent {
  final HangboardExercise hangboardExercise;

  HangboardExerciseDisposed(this.hangboardExercise);

  @override
  String toString() =>
      'HangboardExerciseDisposed { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExercisePreferencesCleared extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  HangboardExercisePreferencesCleared(this.exercise);

  @override
  String toString() =>
      'HangboardExercisePreferencesCleared { exercise: $exercise }';

  @override
  List<Object> get props => [exercise];
}

class HangboardExerciseIncreaseNumberOfHangsButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseIncreaseNumberOfHangsButtonPressed(
      this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseIncreaseNumberOfHangsButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseDecreaseNumberOfHangsButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseDecreaseNumberOfHangsButtonPressed(
      this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseDecreaseNumberOfHangsButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseIncreaseNumberOfSetsButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseIncreaseNumberOfSetsButtonPressed(
      this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseIncreaseNumberOfSetsButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseDecreaseNumberOfSetsButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseDecreaseNumberOfSetsButtonPressed(
      this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseDecreaseNumberOfSetsButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseRepCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  HangboardExerciseRepCompleted(this.exercise);

  @override
  String toString() => 'HangboardExerciseRepCompleted { exercise: $exercise }';

  @override
  List<Object> get props => [exercise];
}

class HangboardExerciseRestCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  HangboardExerciseRestCompleted(this.exercise);

  @override
  String toString() => 'HangboardExerciseRestCompleted { exercise: $exercise }';

  @override
  List<Object> get props => [exercise];
}

class HangboardExerciseBreakCompleted extends HangboardExerciseEvent {
  final HangboardExercise exercise;

  HangboardExerciseBreakCompleted(this.exercise);

  @override
  String toString() =>
      'HangboardExerciseBreakCompleted { exercise: $exercise }';

  @override
  List<Object> get props => [exercise];
}

class HangboardExerciseForwardSwitchButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseForwardSwitchButtonPressed(this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseForwardSwitchButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseReverseSwitchButtonPressed
    extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final TimerBloc timerBloc;

  HangboardExerciseReverseSwitchButtonPressed(this.exercise, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseReverseSwitchButtonPressed { exercise: $exercise }';

  @override
  List<Object> get props => [exercise, timerBloc];
}

class HangboardExerciseForwardComplete extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final Timer timer;
  final TimerBloc timerBloc;

  HangboardExerciseForwardComplete(this.exercise, this.timer, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseForwardComplete { exercise: $exercise, timer: $timer }';

  @override
  List<Object> get props => [exercise, timer];
}

class HangboardExerciseReverseComplete extends HangboardExerciseEvent {
  final HangboardExercise exercise;
  final Timer timer;
  final TimerBloc timerBloc;

  HangboardExerciseReverseComplete(this.exercise, this.timer, this.timerBloc);

  @override
  String toString() =>
      'HangboardExerciseReverseComplete { exercise: $exercise, timer: $timer }';

  @override
  List<Object> get props => [exercise, timer];
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
