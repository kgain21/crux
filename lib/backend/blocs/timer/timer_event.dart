import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent([List props = const []]) : super(props);
}

class LoadTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;

  LoadTimer(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() => 'LoadTimer { hangboardExercise: $hangboardExercise }';
}

/*
class StartTimer extends TimerEvent {
  final Timer timer;

  StartTimer(this.timer) : super([timer]);

  @override
  String toString() => 'StartTimer { timer: $timer }';
}

class PauseTimer extends TimerEvent {
  final Timer timer;

  PauseTimer(this.timer) : super([timer]);

  @override
  String toString() => 'PauseTimer { timer: $timer }';
}
*/

class TimerComplete extends TimerEvent {
  final Timer timer;

  TimerComplete(this.timer) : super([timer]);

  @override
  String toString() => 'TimerComplete { timer: $timer }';
}

class ReplaceWithRepTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;

  ReplaceWithRepTimer(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'ReplaceWithRepTimer { hangboardExercise: $hangboardExercise }';
}

class ReplaceWithRestTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;

  ReplaceWithRestTimer(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'ReplaceWithRestTimer { hangboardExercise: $hangboardExercise }';
}

class ReplaceWithBreakTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;

  ReplaceWithBreakTimer(this.hangboardExercise) : super([hangboardExercise]);

  @override
  String toString() =>
      'ReplaceWithBreakTimer { hangboardExercise: $hangboardExercise }';
}

class DisposeTimer extends TimerEvent {
  final Timer timer;


  DisposeTimer(this.timer) : super([timer]);

  @override
  String toString() => 'DisposeTimer { timer: $timer }';
}

class ClearTimerPreferences extends TimerEvent {
  final Timer timer;

  ClearTimerPreferences(this.timer) : super([timer]);

  @override
  String toString() => 'ClearTimerPreferences { timer: $timer }';
}
