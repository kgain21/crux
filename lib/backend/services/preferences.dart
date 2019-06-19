import 'dart:convert';

import 'package:crux/backend/repository/entities/timer_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences sharedPreferences;

  TimerEntity getTimerPreferences(String timerStorageKey) {
    String timerData = sharedPreferences.getString(timerStorageKey);
    if(timerData != null && timerData.isNotEmpty) {
      return TimerEntity.fromJson(json.decode(timerData));
    } else
      return null;
  }

  Future storeTimerPreferences(String timerStorageKey,
                               TimerEntity timerEntity) {
    return sharedPreferences.setString(
        timerStorageKey, json.encode(timerEntity.toJson()));
  }

  /// SINGLETON
  static final Preferences _preferences = Preferences._internal();

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();
}
