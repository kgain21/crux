import 'package:crux/backend/models/timer/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent([List props = const []]) : super(props);
}

class LoadTimer extends TimerEvent {
  final storageKey;

  LoadTimer(this.storageKey) : super([storageKey]);

  @override
  String toString() => 'LoadTimer { storageKey: $storageKey }';
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
