import 'package:crux/model/timer_direction.dart';
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
  final String lookupKey; // Lookup key for SharedPreferences
  final TimerDirection animationDirection;
  final bool timerPreviouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final int deviceTimeOnReturn; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController

  TimerLoaded(
    this.lookupKey,
    this.animationDirection,
    this.timerPreviouslyRunning,
    this.deviceTimeOnExit,
    this.deviceTimeOnReturn,
    this.controllerValueOnExit,
  );

  @override
  String toString() {
    return 'TimerLoaded: { ' +
        'lookupKey: $lookupKey, ' +
        'animationDirection: $animationDirection, ' +
        'timerPreviouslyRunning: $timerPreviouslyRunning, ' +
        'deviceTimeOnExit: $deviceTimeOnExit, ' +
        'deviceTimeOnReturn: $deviceTimeOnReturn, ' +
        'controllerValueOnExit: $controllerValueOnExit ' +
        '}';
  }
}

class TimerNotLoaded extends TimerState {
  @override
  String toString() => 'TimerNotLoaded';
}