//import 'package:crux/presentation//widgets/workout_timer.dart';
import 'package:crux/backend/models/timer.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  TimerEvent([List props = const []]) : super(props);
}

class LoadTimer extends TimerEvent {
  @override
  String toString() => 'LoadTimer';
}

class AddTimer extends TimerEvent {
  final Timer timer;

  AddTimer(this.timer) : super([timer]);

  @override
  String toString() => 'AddTimer { timer: $timer }';
}

class UpdateTimer extends TimerEvent {
  final Timer timer;

  UpdateTimer(this.timer) : super([timer]);

  @override
  String toString() => 'UpdateTimer { timer: $timer }';
}

class DeleteTimer extends TimerEvent {
  final Timer timer;

  DeleteTimer(this.timer) : super([timer]);

  @override
  String toString() => 'DeleteTimer { timer: $timer }';
}

class TimerComplete extends TimerEvent {
  final Timer timer;

  TimerComplete(this.timer) : super([timer]);

  @override
  String toString() => 'TimerComplete { timer: $timer }';
}

class TimerDispose extends TimerEvent {
  final Timer timer;

  TimerDispose(this.timer) : super([timer]);

  @override
  String toString() => 'TimerDispose { timer: $timer }';
}

class ClearTimerPreferences extends TimerEvent {
  final Timer timer;

  ClearTimerPreferences(this.timer) : super([timer]);

  @override
  String toString() => 'ClearTimerPreferences { timer: $timer }';
}
