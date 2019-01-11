import 'dart:async';
import 'dart:math' as math;
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
  double _timeLeftInMillis;
  int _endTime;
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

  /* Future<void> getTimeLeftInMillis() async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _timeLeftInMillis =
          (preferences.getDouble('${_id}timeLeftInMillis') ?? 0.0);
    });
  }*/

  void setTimeLeftInMillis(double timeLeftInMillis) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setDouble('${_id}timeLeftInMillis', timeLeftInMillis);
  }

  /*Future<void> getTimerRunning() async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _timerRunning = (preferences.getBool('${_id}timerRunning') ?? false);
    });
  }*/

  void setTimerRunning(bool timerRunning) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setBool('${_id}timerRunning', timerRunning);
  }

  /*Future<void> getForwardAnimation() async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _forwardAnimation = (preferences.getBool('${_id}forwardAnimation') ?? false);
    });
  }*/

  void setForwardAnimation(bool forwardAnimation) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setBool('${_id}forwardAnimation', forwardAnimation);
  }

  /*Future<void> getEndTime() async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _endTime = (preferences.getInt('${_id}endTime') ?? 0);
    });
  }*/

  void setEndTime(int endTime) async {
    final SharedPreferences preferences = await _sharedPreferences;
    preferences.setInt('${_id}endTime', endTime);
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
        _endTime = (preferences.getInt('${_id}endTime') ?? 0);

        _forwardAnimation =
            (preferences.getBool('${_id}forwardAnimation') ?? false);

        _timerRunning = (preferences.getBool('${_id}timerRunning') ?? false);

        /// If there is no timeLeftInMillis, check forwardAnimation and set to
        /// appropriate start time converted to millis
        _timeLeftInMillis = (preferences.getDouble('${_id}timeLeftInMillis') ??
            (_forwardAnimation
                ? widget.restTime * 1000.0
                : widget.repTime * 1000.0));

        /// If there is no endValue stored, check forwardAnimation and set to
        /// appropriate start value
        _endValue = (preferences.getDouble('${_id}endValue') ??
            (_forwardAnimation ? 0.0 : 1.0));
      });
    }
  }

  void checkIfPreviouslyRunning() async {

    await getSharedPrefs();

    /// ~/ is rounded division toInt I guess
    /// //TODO: POTENTIAL ROUNDING ERROR
    /// //TODO: EDIT: DOESN"T LOOK LIKE IT"S ACTUALLY USED?
    int timeLeftInSeconds = _timeLeftInMillis ~/ 1000;

    /// Check to see if there is a difference between the prefs timeLeft and the
    /// repTime or restTime.
    /// If there is, that means we need to load the old time, possibly
    /// subtract the elapsed time, and start it if it was running.
    /// Otherwise, we initialize the new controller w/ appropriate values.
    if (timeLeftInSeconds == widget.repTime) {
      _controller = AnimationController(
        value: 1.0,
        vsync: this,
        duration: Duration(seconds: widget.repTime),
      );
    } else if (timeLeftInSeconds == widget.restTime) {
      _controller = AnimationController(
        value: 0.0,
        vsync: this,
        duration: Duration(seconds: widget.restTime),
      );
    } else {
      /// Controller was left in a different state than when it started so need to initialize with new calculated time and start it appropriately
      /// This accounts for timer left running or paused - abstracted to calculation methods
      /// TODO: Left off here 1/10: getting very close but the calculations seems waaay off. Going to have to figure out a way to not round as much.
      /// TODO: 1/11: More progress but was focusing on stopped timer retrieval -- drops 2 seconds on every retrieval which makes NOOO sense
      Duration duration = await calculateNewDuration();
      double value = await calculateNewValue();
      if (_forwardAnimation) {
        _controller = AnimationController(
          value: value,
          vsync: this,
          duration: duration,
        );
        if (_timerRunning) {
          _controller.forward(from: value);
        }
      } else {
        _controller = AnimationController(
          value: value,
          vsync: this,
          duration: duration,
        );
        if (_timerRunning) {
          _controller.reverse(from: value);
        }
      }
    }
  }

  Future<Duration> calculateNewDuration() async {
    int calculatedTimeLeft;
    int originalDuration;

    /// OriginalDuration makes sure that the subtracted time doesn't exceed the
    /// given rep or rest time
    if (_forwardAnimation)
      originalDuration = widget.restTime;
    else
      originalDuration = widget.repTime;

    /// If the timer was running when stopped, calculated the elapsed time and
    /// subtract; otherwise just get the time that was left when stopped.
    if (_timerRunning)
      calculatedTimeLeft = subtractElapsedTimeFromDuration(originalDuration);
    else
      calculatedTimeLeft = _timeLeftInMillis.toInt();

    return Duration(milliseconds: calculatedTimeLeft);
  }

  int subtractElapsedTimeFromDuration(int originalDuration) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int elapsedTime = currentTime - _endTime;
    int timeRemaining = (_timeLeftInMillis - elapsedTime).toInt();

    /// Don't want to display a negative value, so we need this check
    /// OriginalDuration needs to be converted to millis here
    if (timeRemaining <= 0) {
      if (_forwardAnimation) {
        return widget.repTime;
      } else {
        return widget.restTime;
      }
    } else
      return timeRemaining;
  }

  Future<double> calculateNewValue() async {
    if (_timerRunning) {
      return valueDifference();
    } else {
      return _endValue;
    }
  }

  double valueDifference() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int elapsedTime = currentTime - _endTime;
    double timeRemaining = _timeLeftInMillis - elapsedTime;
    if (_forwardAnimation) {
      return 1.0 - (timeRemaining / (widget.restTime * 1000.0));
    } else {
      return timeRemaining / (widget.repTime * 1000.0);
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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

  void setSharedPrefsBeforeDispose() {
    setForwardAnimation(_forwardAnimation);
    setEndValue(_controller.value);

    /// Forward and reverse have to be calculated differently - forward needs
    /// to be 1 - value
    if (_forwardAnimation)
      setTimeLeftInMillis(
          (1 - _controller.value) * _controller.duration.inMilliseconds);
    else
      setTimeLeftInMillis(
          _controller.value * _controller.duration.inMilliseconds);

    setEndTime(DateTime.now().millisecondsSinceEpoch);
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
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
