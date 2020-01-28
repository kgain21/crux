import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent();
}

class TimerLoaded extends TimerEvent {
  final HangboardExercise hangboardExercise;
  final isTimerRunning;

  TimerLoaded(this.hangboardExercise, this.isTimerRunning);

  @override
  String toString() => 'TimerLoaded { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise, isTimerRunning];
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

class TimerCompleted extends TimerEvent {
  final Timer timer;

  TimerCompleted(this.timer);

  @override
  String toString() => 'TimerCompleted { timer: $timer }';

  @override
  List<Object> get props => [timer];
}

class TimerReplacedWithRepTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;
  final bool isTimerRunning;

  TimerReplacedWithRepTimer(this.hangboardExercise, this.isTimerRunning);

  @override
  String toString() =>
      'TimerReplacedWithRepTimer { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise, isTimerRunning];
}

class TimerReplacedWithRestTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;
  final bool isTimerRunning;

  TimerReplacedWithRestTimer(this.hangboardExercise, this.isTimerRunning);

  @override
  String toString() =>
      'TimerReplacedWithRestTimer { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise, isTimerRunning];
}

class TimerReplacedWithBreakTimer extends TimerEvent {
  final HangboardExercise hangboardExercise;
  final bool isTimerRunning;

  TimerReplacedWithBreakTimer(this.hangboardExercise, this.isTimerRunning);

  @override
  String toString() =>
      'TimerReplacedWithBreakTimer { hangboardExercise: $hangboardExercise }';

  @override
  List<Object> get props => [hangboardExercise, isTimerRunning];
}

class TimerDisposed extends TimerEvent {
  final Timer timer;

  TimerDisposed(this.timer);

  @override
  String toString() => 'TimerDisposed { timer: $timer }';

  @override
  List<Object> get props => [timer];
}

class TimerPreferencesCleared extends TimerEvent {
  final Timer timer;

  TimerPreferencesCleared(this.timer);

  @override
  String toString() => 'TimerPreferencesCleared { timer: $timer }';

  @override
  List<Object> get props => [timer];
}
