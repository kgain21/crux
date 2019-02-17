import 'dart:async';

import 'package:crux/utils/timer_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutTimer extends StatefulWidget {
  final int time;
  final String id;
  final bool switchForward;
  final bool switchTimer;
  final VoidCallback notifyParentReverseComplete;
  final VoidCallback notifyParentForwardComplete;

  WorkoutTimer(
      {this.switchForward,
      this.switchTimer,
      this.time,
      this.id,
      this.notifyParentForwardComplete,
      this.notifyParentReverseComplete});

  @override
  State createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  bool _forwardAnimation;
  int _endTimeMillis;
  bool _timerRunning;
  String _id;
  double _endValue;
  int _currentTime;
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  String get timerString {
    Duration duration;
    bool forwardAnimation = widget.switchTimer
        ? widget.switchForward
        : (_forwardAnimation ?? false);
    if (forwardAnimation) {
      duration = _controller.duration * (1 - _controller.value);
    } else {
      duration = _controller.duration * _controller.value;
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}.${(duration.inMilliseconds % 100).toString().padLeft(2, '0')}';
  }

  void setTimerRunning(bool timerRunning) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setBool('${_id}timerRunning', timerRunning);
  }

  void setForwardAnimation(bool forwardAnimation) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setBool('${_id}forwardAnimation', forwardAnimation);
  }

  void setEndTimeMillis(int endTimeMillis) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setInt('${_id}endTimeMillis', endTimeMillis);
  }

  void setEndValue(double endValue) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setDouble('${_id}endValue', endValue);
  }

  void setTime(int seconds) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setInt('${_id}time', _currentTime);
  }

  /// Get all sharedPrefs at once during build
  void getSharedPrefs(SharedPreferences preferences) {
    _endTimeMillis = (preferences.getInt('${_id}endTimeMillis') ?? 0);

    _forwardAnimation =
        (preferences.getBool('${_id}forwardAnimation') ?? false);

    _timerRunning = (preferences.getBool('${_id}timerRunning') ?? false);

    /// If there is no endValue stored, check forwardAnimation and set to
    /// appropriate start value
    _endValue = (preferences.getDouble('${_id}endValue') ??
        (_forwardAnimation ? 0.0 : 1.0));

    /// This is for reloading an already running timer.
    /// The assumption is that if there is a value here the timer was left in a
    /// running state and needs to use this value.
    /// Otherwise, rebuild the timer with whatever new time came in.
    _currentTime = (preferences.getInt('${_id}time')) ?? widget.time;
  }

  @override
  void initState() {
    print('Timer ${widget.id} initState');
    super.initState();
    _id = widget.id;
  }

  @override
  void didChangeDependencies() {
    print('Timer ${widget.id} didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('Timer ${widget.id} build');
    super.build(context);
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context, sharedPrefs) {
        return sharedPrefs.hasData
            ? workoutTimer(sharedPrefs.data)
            : loadingScreen();
      },
    );
  }

  @override
  void dispose() {
    print('Timer ${widget.id} dispose');
    setSharedPrefsBeforeDispose();

    _controller.stop();
    _controller.dispose();

    super.dispose();
  }

  /*vvv INITSTATE METHODS vvv*/

  void checkIfPreviouslyRunning(SharedPreferences preferences) {
    getSharedPrefs(preferences);
    double value = calculateNewValue();
    setupController(value);
  }

  /// Creates an AnimationController based on whether or not the timer should
  /// be animating forward or not. The duration is the rest duration if
  /// forward, or rep duration if reverse. Value is calculated if the timer
  /// was left running or retrieved from memory if stopped.
  void setupController(double value) {
    _controller = new AnimationController(
        vsync: this, value: value, duration: Duration(seconds: _currentTime));
    if (_timerRunning) {
      if (_forwardAnimation)
        _controller.forward(from: value);
      else
        _controller.reverse(from: value);
    }
  }

  double calculateNewValue() {
    if (_timerRunning) {
      return valueDifference();
    } else {
      return _endValue;
    }
  }

  /// Finds the difference in time from the saved ending system time and the
  /// current system time and divides that by the starting duration to get the
  /// new value accounting for elapsed time.
  double valueDifference() {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;
    int elapsedDuration = currentTimeMillis - _endTimeMillis;
    double endDuration = _endValue * (_currentTime * 1000.0);
    double value;

    /// If animating forward and the calculated value difference is less than 0,
    /// return 0.0 as the value (can't have a negative value).
    /// Else if difference is greater than 1, return 1.
    /// Finally, return calculated value if neither of the above are true.
    if (_forwardAnimation) {
      value = (endDuration + elapsedDuration) / (_currentTime * 1000.0);
      if (value <= 0.0) return 0.0;
    } else {
      value = (endDuration - elapsedDuration) / (_currentTime * 1000.0);
      if (value >= 1) return 1.0;
    }
    return value;
  }

/*^^^ INITSTATE METHODS ^^^*/

/*vvv BUILD METHODS vvv*/

  /// Checks if switch flag was passed in - this should signal a new build of the
  /// timer with the passed in new time and opposite direction.
  ///
  /// Since the timer only rebuilds when being switched, the [switchTimer] flag
  /// will always start false at initialization and become true from the first
  /// user switch up until it is disposed of.
  /// The only flag that will change is the [switchForward] flag each time the
  /// user switches times.
  void checkIfResetTimer() {
    if (widget.switchTimer) {
      double value;
      if (widget.switchForward) {
        value = 0.0;
      } else {
        value = 1.0;
      }
      _timerRunning = false;
      _currentTime = widget.time;
      _forwardAnimation = widget.switchForward;
      _controller.value = value;
      _controller.duration = Duration(seconds: _currentTime);
    }
  }

  Widget workoutTimer(SharedPreferences preferences) {
    checkIfPreviouslyRunning(preferences);
    checkIfResetTimer();
    return GestureDetector(
      onTap: () {
        startStopTimer(_controller);
      },
      onLongPress: () {
        resetTimer(_controller);
      },
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Stack(
          children: <Widget>[
            circularTimer(),
            timerText(),
          ],
        ),
      ),
    );
  }

  /// Widget that builds a circular timer using [TimerPainter]. This timer is
  /// controlled by the [_controller] and is the main visual component of the
  /// [WorkoutTimer].
  Widget circularTimer() {
    return Positioned(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: TimerPainter(
              animation: _controller,
              backgroundColor: Theme.of(context).primaryColorDark,
              color: Theme.of(context).accentColor,
            ),
            child: //RaisedButton(onPressed: null, color: Theme.of(context).canvasColor,shape: CircleBorder(),),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).canvasColor),
                  ),
                ),
          );
        },
      ),
    );
  }

  /// Widget that builds the [timerString] for the [WorkoutTimer].
  /// The string is displayed in Minutes:Seconds:Milliseconds and is controlled
  /// by [_controller].
  Widget timerText() {
    return Align(
      alignment: FractionalOffset.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Text(
                timerString,
                style: TextStyle(
                  fontSize: 30.0,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  /// Controls starting or stopping the [_controller] and determines which
  /// way it should animate using the boolean [_forwardAnimation], where true is
  /// forward and false is reverse. This method is passed to the onClickEvent
  /// of the [WorkoutTimer].
  ///
  /// When the animation completes, a notification is sent to the parent
  /// [WorkoutScreen] widget to tell it that it has finished.
  ///
  /// Additionally, the [SharedPreferences] get nulled out so that future timers
  /// don't try to read old values.
  void startStopTimer(AnimationController controller) {
    if (controller.isAnimating) {
      setTimerRunning(false);
      controller.stop(canceled: false);
    } else {
      setTimerRunning(true);
      if (!_forwardAnimation) {
        controller.reverse().whenComplete(() {
          if (controller.status == AnimationStatus.dismissed) {
            //TODO: pull this out into a function
            setTimerRunning(false);
            setTime(null);
            setEndValue(null);
            setEndTimeMillis(null);
            widget.notifyParentReverseComplete();
          }
        }).catchError(handleError);
      } else {
        controller.forward().whenComplete(() {
          if (controller.status == AnimationStatus.completed) {
            setTimerRunning(false);
            setTime(null);
            setEndValue(null);
            setEndTimeMillis(null);
            widget.notifyParentForwardComplete();
          }
        }).catchError(handleError);
      }
    }
  }

  //TODO: make this do more
  void handleError(Error error) {
    print('Printing from WorkoutTimer handleError: $error');
  }

  /// Resets the timer based on its current status. This method is passed to the
  /// onLongPress event of the circular timer.
  void resetTimer(AnimationController controller) {
    setTimerRunning(false);
    if (controller.isAnimating) {
      controller.stop(canceled: false);
      if (controller.status == AnimationStatus.reverse) {
        setState(() {
          controller.value = 1.0;
        });
      } else if (controller.status == AnimationStatus.forward) {
        setState(() {
          controller.value = 0.0;
        });
      }
    } else {
      if (controller.status == AnimationStatus.reverse) {
        setState(() {
          controller.value = 1.0;
        });
      } else if (controller.status == AnimationStatus.forward) {
        setState(() {
          controller.value = 0.0;
        });
      }
    }
  }

  Widget loadingScreen() {
    return Column(
      children: <Widget>[],
    );
  }

/*^^^ BUILD METHODS ^^^*/

/*vvv DISPOSE METHODS vvv*/
  void setSharedPrefsBeforeDispose() {
    setForwardAnimation(_forwardAnimation);
    setEndValue(_controller.value ?? 0.0);
    setEndTimeMillis(DateTime.now().millisecondsSinceEpoch);
    setTime(_currentTime);
  }

/*^^^ DISPOSE METHODS ^^^*/

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
