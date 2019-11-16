import 'package:crux/backend/models/timer/timer.dart';
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
  final Timer timer;
  final double controllerValue;
  final bool isTimerRunning;

  TimerLoaded(this.timer,
              this.controllerValue,
              this.isTimerRunning,)
      : super([timer, controllerValue, isTimerRunning]);

  @override
  String toString() {
    return 'TimerLoaded: { '
        'timer: ${timer.toString()}'
        '}';
  }
}

class TimerNotLoaded extends TimerState {
  @override
  String toString() => 'TimerNotLoaded';
}

class TimerDisposed extends TimerState {
  @override
  String toString() => 'TimerDisposed';
}
