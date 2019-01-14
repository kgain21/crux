import 'dart:async';
import 'package:crux/utils/timer_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerTextAnimator extends StatefulWidget {
  final int repTime;
  final int restTime;
  final int hangs;
  final String id;

  TimerTextAnimator({this.repTime, this.restTime, this.hangs, this.id});

  @override
  State createState() => _TimerTextAnimatorState();
}

class _TimerTextAnimatorState extends State<TimerTextAnimator>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  bool _forwardAnimation;
  int _hangs;
  int _endTimeMillis;
  bool _timerRunning;
  String _id;
  double _endValue;
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  String get timerString {
    Duration duration;
    if (_forwardAnimation) {
      duration = _controller.duration * (1 - _controller.value);
    } else {
      duration = _controller.duration * _controller.value;
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
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

  /// Decided to get all sharedPrefs at once so I wasn't calling multiple setStates
  /// and using multiple futures at the same time
  Future<void> getSharedPrefs() async {
    final SharedPreferences preferences = await _sharedPreferences;
    if (mounted) {
      setState(() {
        _endTimeMillis = (preferences.getInt('${_id}endTimeMillis') ?? 0);

        _forwardAnimation =
            (preferences.getBool('${_id}forwardAnimation') ?? false);

        _timerRunning = (preferences.getBool('${_id}timerRunning') ?? false);

        /// If there is no endValue stored, check forwardAnimation and set to
        /// appropriate start value
        _endValue = (preferences.getDouble('${_id}endValue') ??
            (_forwardAnimation ? 0.0 : 1.0));
      });
    }
  }


  @override
  void initState() {
    super.initState();
    _id = widget.id;

    checkIfPreviouslyRunning();

    //TODO: this doesn't work bc hangs are sent in from parent widget, need to add a listener in parent for completedForwardAnimation
    _hangs = widget.hangs;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        startStopTimer(_controller);
      },
      onLongPress: () {
        resetTimer(_controller);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  circularTimer(),
                  timerText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    setSharedPrefsBeforeDispose();

    _controller.stop();
    _controller.dispose();

    super.dispose();
  }

  /*vvv INITSTATE METHODS vvv*/

  void checkIfPreviouslyRunning() async {
    //TODO: Trace where exception is coming from starting here
    await getSharedPrefs();

    /// Creates an AnimationController based on whether or not the timer should
    /// be animating forward or not. The duration is the rest duration if
    /// forward, or rep duration if reverse. Value is calculated if the timer
    /// was left running or retrieved from memory if stopped.
    double value = await calculateNewValue();
    if (_forwardAnimation) {
      _controller = AnimationController(
        value: value,
        vsync: this,
        duration: Duration(seconds: widget.restTime),
      );
      if (_timerRunning) {
        _controller.forward(from: value);
      }
    } else {
      _controller = AnimationController(
        value: value,
        vsync: this,
        duration: Duration(seconds: widget.repTime),
      );
      if (_timerRunning) {
        _controller.reverse(from: value);
      }
    }
  }

  Future<double> calculateNewValue() async {
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
    double endDuration;
    if (_forwardAnimation) {
      endDuration = _endValue * (widget.restTime * 1000.0);
      double forwardValue =
          (endDuration + elapsedDuration) / (widget.restTime * 1000.0);
      if (forwardValue <= 0)
        return 0.0;
      else
        return forwardValue;
    } else {
      endDuration = _endValue * (widget.repTime * 1000.0);
      double reverseValue =
          (endDuration - elapsedDuration) / (widget.repTime * 1000.0);
      if (reverseValue >= 1)
        return 1.0;
      else
        return reverseValue;
    }
  }

  /*^^^ INITSTATE METHODS ^^^*/

  /*vvv BUILD METHODS vvv*/

  Widget circularTimer() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return new CustomPaint(
            painter: TimerPainter(
              animation: _controller,
              backgroundColor: Colors.black,
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }

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
              return new Text(
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

  /// Controls starting or stopping the AnimationController and determines which
  /// way it should animate. This method is passed to the onClickEvent of the
  /// circularTimer.
  void startStopTimer(AnimationController controller) {
    if (controller.isAnimating) {
      setTimerRunning(false);
      controller.stop(canceled: false);
    } else {
      setTimerRunning(true);
      if (!_forwardAnimation) {
        try {
          controller.reverse().whenComplete(() {
            if (controller.status == AnimationStatus.dismissed) {
              setState(() {
                controller.value = 0.0;
                controller.duration = Duration(seconds: widget.restTime);
                _forwardAnimation = true;
              });
            }
          });
          //TODO: I don't think these do anything - how do i test/handle these?
        } on TickerCanceled {
          print('TickerCanceled');
        } on Exception {
          print('Exception');
        } on Error {
          print('Error');
        }
      } else {
        try {
          controller.forward().whenComplete(() {
            if (controller.status == AnimationStatus.completed) {
              setState(() {
                controller.value = 1.0;
                controller.duration = Duration(seconds: widget.repTime);
                _forwardAnimation = false;
                _hangs -= 1;
              });
            }
          });
        } on TickerCanceled {
          print('TickerCanceled');
        } on Exception {
          print('Exception');
        } on Error {
          print('Error');
        }
      }
    }
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

  /*^^^ BUILD METHODS ^^^*/

  /*vvv DISPOSE METHODS vvv*/
  void setSharedPrefsBeforeDispose() {
    setForwardAnimation(_forwardAnimation);
    setEndValue(_controller.value);
    setEndTimeMillis(DateTime.now().millisecondsSinceEpoch);
  }

  /*^^^ DISPOSE METHODS ^^^*/

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
