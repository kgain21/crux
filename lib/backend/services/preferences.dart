import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences sharedPreferences;

  int getEndTimeMillis(String storageKey) {
    _endTimeMillis = (preferences.getInt('$_id EndTimeMillis') ?? 0);

    _forwardAnimation = (preferences.getBool('$_id ForwardAnimation') ?? false);

    _timerPreviouslyRunning =
        (preferences.getBool('$_id TimerPreviouslyRunning') ?? false);

    /// If there is no endValue stored, check forwardAnimation and set to
    /// appropriate start value
    _endValue = (preferences.getDouble('$_id EndValue') ??
        (_forwardAnimation ? 0.0 : 1.0));

    /// This is for reloading an already running timer.
    /// The assumption is that if there is a value here the timer was left in a
    /// running state and needs to use this value.
    /// Otherwise, rebuild the timer with whatever new time came in.
    _currentTime = (preferences.getInt('$_id Time')) ?? widget.time;
  }

  void setTimerPreviouslyRunning(bool timerRunning, String storageKey) async {
//    final SharedPreferences prefs = await sharedPreferences;

    sharedPreferences.setBool(
        '$storageKey TimerPreviouslyRunning', timerRunning);
  }

  void setForwardAnimation(bool forwardAnimation, String storageKey) async {
//    final SharedPreferences prefs = await sharedPreferences;

    sharedPreferences.setBool('$storageKey ForwardAnimation', forwardAnimation);
  }

  void setEndTimeMillis(int endTimeMillis, String storageKey) async {
//    final SharedPreferences prefs = await sharedPreferences;

    sharedPreferences.setInt('$storageKey EndTimeMillis', endTimeMillis);
  }

  void setEndValue(double endValue, String storageKey) async {
//    final SharedPreferences prefs = await sharedPreferences;

    sharedPreferences.setDouble('$storageKey EndValue', endValue);
  }

  //todo: see where this is used - setting seconds doesn't seem very useful, may just be poorly named
  void setTime(int seconds, String storageKey) async {
//    final SharedPreferences prefs = await sharedPreferences;

    sharedPreferences.setInt('$storageKey CurrentTime', seconds);
  }

  /// SINGLETON
  static final Preferences _preferences = Preferences._internal();

  factory Preferences() {
    return _preferences;
  }

  Preferences._internal();
}
