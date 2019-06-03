enum SharedPreferencesKeys {
  TimerDuration,
  TimerDirection,
  TimerPreviouslyRunning,
  DeviceTimeOnExit,
  DeviceTimeOnReturn,
  ControllerValueOnExit,
}

String keyToString(SharedPreferencesKeys k) {
  return '$k'
      .split('.')
      .last;
}