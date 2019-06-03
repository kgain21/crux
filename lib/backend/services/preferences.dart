import 'dart:convert';

import 'package:crux/backend/repository/entities/timer_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences sharedPreferences;

  TimerEntity getTimerPreferences(String timerStorageKey) {
    return TimerEntity.fromJson(
        json.decode(sharedPreferences.getString(timerStorageKey)));
  }

  void storeTimerPreferences(TimerEntity timerEntity, String timerStorageKey) {
    sharedPreferences.setString(
        timerStorageKey, json.encode(timerEntity.toJson()));
  }

  /// SINGLETON
  static final Preferences _preferences = Preferences._internal();

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();
}
