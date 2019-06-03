import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

///
/// Class containing the state of the CircularTimer used in Hangboard workouts.
///
/// This state is used to persist and retrieve timer state if a user leaves the
/// screen or application. Values are stored to look up the time that the user
/// left at, and calculate the elapsed time if it was left in a running state.
///
@immutable
abstract class TimerState extends Equatable {
  TimerState([List props = const []]) : super(props);
}

class TimerLoading extends TimerState {
  @override
  String toString() => 'TimerLoading';
}

class TimerLoaded extends TimerState {
  final String storageKey; // Storage key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool previouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final int deviceTimeOnReturn; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController

  TimerLoaded(this.storageKey,
              this.duration,
              this.direction,
              this.previouslyRunning,
              this.deviceTimeOnExit,
              this.deviceTimeOnReturn,
              this.controllerValueOnExit,) : super([
    storageKey,
    duration,
    direction,
    previouslyRunning,
    deviceTimeOnExit,
    deviceTimeOnReturn,
    controllerValueOnExit,
  ]);

  @override
  String toString() {
    return 'TimerLoaded: { '
        'storageKey: $storageKey, '
        'duration: $duration, '
        'direction: $direction, '
        'previouslyRunning: $previouslyRunning, '
        'deviceTimeOnExit: $deviceTimeOnExit, '
        'deviceTimeOnReturn: $deviceTimeOnReturn, '
        'controllerValueOnExit: $controllerValueOnExit '
        '}';
  }
}

class TimerNotLoaded extends TimerState {
  @override
  String toString() => 'TimerNotLoaded';
}
