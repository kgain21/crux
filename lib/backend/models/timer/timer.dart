import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/backend/repository/entities/timer_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Timer extends Equatable {
  final String storageKey; // Storage key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool previouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final int deviceTimeOnReturn; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController

  //TODO: Don't think I want to import these - look like UI packages
  // final VoidCallback notifyParentReverseComplete;
  //final VoidCallback notifyParentForwardComplete;
  //TODO: figure out what to do with them / if i need them anymore

//  final bool startTimer;
//  final bool preferencesClearedFlag;

  Timer(this.storageKey,
        this.duration,
        this.direction,
        this.previouslyRunning,
        this.deviceTimeOnExit,
        this.deviceTimeOnReturn,
        this.controllerValueOnExit,);

  Timer copyWith({
                   String lookupKey,
                   int timerDuration,
                   TimerDirection timerDirection,
                   bool timerPreviouslyRunning,
                   int deviceTimeOnExit,
                   int deviceTimeOnReturn,
                   double controllerValueOnExit,
                 }) {
    return Timer(
      lookupKey,
      timerDuration,
      timerDirection,
      timerPreviouslyRunning,
      deviceTimeOnExit,
      deviceTimeOnReturn,
      controllerValueOnExit,
    );
  }

  @override
  String toString() {
    return 'Timer { storageKey: $storageKey, duration: $duration, '
        'direction: $direction, previouslyRunning: $previouslyRunning,'
        'deviceTimeOnExit: $deviceTimeOnExit, deviceTimeOnReturn: $deviceTimeOnReturn,'
        'controllerValueOnExit: $controllerValueOnExit';
  }

  TimerEntity toEntity() {
    return TimerEntity(
      storageKey,
      duration,
      direction,
      previouslyRunning,
      deviceTimeOnExit,
      deviceTimeOnReturn,
      controllerValueOnExit,
    );
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(
      entity.storageKey,
      entity.duration,
      entity.direction,
      entity.previouslyRunning,
      entity.deviceTimeOnExit,
      entity.deviceTimeOnReturn,
      entity.controllerValueOnExit,
    );
  }
}
