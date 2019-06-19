import 'package:crux/backend/models/timer/timer_direction.dart';

//TODO: ADD COLOR??? ANYTHING ELSE I WANT TO ADD?
class TimerEntity {
  final String storageKey; // Lookup key for SharedPreferences
  final int duration;
  final TimerDirection direction;
  final bool previouslyRunning;
  final int deviceTimeOnExit; // In epoch milliseconds
  final int deviceTimeOnReturn; // In epoch milliseconds
  final double controllerValueOnExit; // Value of animationController

  TimerEntity(this.storageKey,
              this.duration,
              this.direction,
              this.previouslyRunning,
              this.deviceTimeOnExit,
              this.deviceTimeOnReturn,
              this.controllerValueOnExit,);

  @override
  String toString() {
    return 'TimerEntity { storageKey: $storageKey, duration: $duration, '
        'direction: $direction, previouslyRunning: $previouslyRunning,'
        'deviceTimeOnExit: $deviceTimeOnExit, deviceTimeOnReturn: $deviceTimeOnReturn,'
        'controllerValueOnExit: $controllerValueOnExit';
  }

  Map<String, Object> toJson() {
    return {
      "storageKey": storageKey,
      "duration": duration,
      "direction": direction,
      "previouslyRunning": previouslyRunning,
      "deviceTimeOnExit": deviceTimeOnExit,
      "deviceTimeOnReturn": deviceTimeOnReturn,
      "controllerValueOnExit": controllerValueOnExit,
    };
  }

  //todo: defaults here for timer that is just loaded and doesn't have sharedprefs yet?
  //todo: defaults should be what's passed in for exercise ideally
  static TimerEntity fromJson(Map<String, Object> json) {
    return TimerEntity(
      json["storageKey"] as String ?? '',
      //todo: not sure if this actually works
      json["duration"] as int,
      json["direction"] as TimerDirection,
      json["previouslyRunning,"] as bool,
      json["deviceTimeOnExit,"] as int,
      json["deviceTimeOnReturn,"] as int,
      json["controllerValueOnExit,"] as double,
    );
  }
}
