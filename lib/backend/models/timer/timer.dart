import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/backend/repository/entities/timer_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

@immutable
class Timer extends Equatable {
  final String storageKey; // Storage key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool previouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController

  Timer(this.storageKey,
        this.duration,
        this.direction,
        this.previouslyRunning,
        this.deviceTimeOnExit,
        this.controllerValueOnExit,);

  Timer copyWith({
                   String lookupKey,
                   int duration,
                   TimerDirection direction,
                   bool previouslyRunning,
                   int deviceTimeOnExit,
                   double controllerValueOnExit,
                 }) {
    return Timer(
      lookupKey,
      duration,
      direction,
      previouslyRunning,
      deviceTimeOnExit,
      controllerValueOnExit,
    );
  }

  @override
  String toString() {
    return 'Timer { storageKey: $storageKey, duration: $duration, '
        'direction: $direction, previouslyRunning: $previouslyRunning,'
        'deviceTimeOnExit: $deviceTimeOnExit, controllerValueOnExit: $controllerValueOnExit';
  }

  TimerEntity toEntity() {
    return TimerEntity(
      storageKey,
      duration,
      direction,
      previouslyRunning,
      deviceTimeOnExit,
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
      entity.controllerValueOnExit,
    );
  }
}
