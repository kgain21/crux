import 'package:crux/widgets/workout_timer.dart';
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
  final WorkoutTimer workoutTimer;

  AddTimer(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'AddTimer { workoutTimer: $workoutTimer }';
}

class UpdateTimer extends TimerEvent {
  final WorkoutTimer workoutTimer;

  UpdateTimer(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'UpdateTimer { workoutTimer: $workoutTimer }';
}

class DeleteTimer extends TimerEvent {
  final WorkoutTimer workoutTimer;

  DeleteTimer(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'DeleteTimer { workoutTimer: $workoutTimer }';
}

class TimerComplete extends TimerEvent {
  final WorkoutTimer workoutTimer;

  TimerComplete(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'TimerComplete { workoutTimer: $workoutTimer }';
}

class TimerDispose extends TimerEvent {
  final WorkoutTimer workoutTimer;

  TimerDispose(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'TimerDispose { workoutTimer: $workoutTimer }';
}

class ClearTimerPreferences extends TimerEvent {
  final WorkoutTimer workoutTimer;

  ClearTimerPreferences(this.workoutTimer) : super([workoutTimer]);

  @override
  String toString() => 'ClearTimerPreferences { workoutTimer: $workoutTimer }';
}
