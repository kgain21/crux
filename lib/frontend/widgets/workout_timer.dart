/*
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
  final bool startTimer;
  final bool preferencesClearedFlag;

  WorkoutTimer({this.switchForward,
                 this.switchTimer,
                 this.time,
                 this.id,
                 this.notifyParentForwardComplete,
                 this.notifyParentReverseComplete,
                 this.startTimer,
                 this.preferencesClearedFlag});

  @override
  State createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;

  bool _forwardAnimation;
  int _endTimeMillis;
  bool _timerPreviouslyRunning;
  String _id;
  double _endValue;
  int _currentTime;

  //Preferences _preferences;

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
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
.${(duration.inMilliseconds % 100).toString().padLeft(2, '0')}';

  }


  @override
  void initState() {
    print('Timer ${widget.id} initState');
    super.initState();
    _controller = AnimationController(
        vsync: this, value: 1.0, duration: Duration(seconds: widget.time));
    _id = widget.id;
//    _preferences = Preferences();
//    (context.inheritFromWidgetOfExactType(MyApp) as MyApp).sharedPreferences;
//    _sharedPreferences = SharedPreferences.getInstance();
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
    return StreamBuilder(
      stream: Preferences.sharedPreferences,
      builder: (context, sharedPreferences) {
        _sharedPreferences = sharedPreferences.data;
        return sharedPreferences.hasData
            ? workoutTimer(sharedPreferences.data)
            : loadingScreen();
      },
    );
  }

  Widget workoutTimer(SharedPreferences preferences) {
    ///retrieve prefs from device or set defaults if not present
    getSharedPrefs(preferences);

    /// Gets the difference in time if timer was left running
    /// Gets 0.0 or 1.0 if time was exceeded in either direction
    /// Get value of animation if stopped
    double value = getValueIfTimerPreviouslyRunning();

    /// Resets value to 0.0 or 1.0 if one of the switch timer buttons was pressed
    value = checkIfResetTimer(value);

    /// Creates controller with appropriate animation value determined above
    setupController(value);

    // checkIfPreviouslyRunning();
    // checkIfShouldStart();
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
              backgroundColor: Theme
                  .of(context)
                  .canvasColor,
              color: Theme
                  .of(context)
                  .accentColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme
                        .of(context)
                        .primaryColorLight),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Widget that builds the [timerString] for the [WorkoutTimer].
  /// The string is displayed in Minutes:Seconds and is controlled
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
                  fontSize: 50.0,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget loadingScreen() {
    return Column(
      children: <Widget>[
Empty to help avoid any flickering from quick loads

      ],
    );
  }

  @override
  void dispose() {
    print('Timer ${widget.id} dispose');
    setSharedPrefsBeforeDispose();

    if (_controller != null) {
      _controller.stop();
      _controller.dispose();
    }

    super.dispose();
  }

vvv INITSTATE METHODS vvv

//  Started waiting for sharedPrefs to come back in build so everything that was
//  here went to the build methods
^^^ INITSTATE METHODS ^^^


vvv BUILD METHODS vvv



//*
// Get all sharedPrefs at once during build
  void getSharedPrefs(SharedPreferences preferences) {
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


  double getValueIfTimerPreviouslyRunning() {
    if (_timerPreviouslyRunning) {
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

  /// Creates an AnimationController based on whether or not the timer should
  /// be animating forward or not. The duration is the rest duration if
  /// forward, or rep duration if reverse. Value is calculated if the timer
  /// was left running or retrieved from memory if stopped.
  void setupController(double value) {
//    _controller = new AnimationController(
//        vsync: this, value: value, duration: Duration(seconds: _currentTime));

    _controller.value = value;
    _controller.duration = Duration(seconds: _currentTime);
    if (_timerPreviouslyRunning) {
      setupControllerCallback(_controller);
    }
  }

  /// Checks if switch flag was passed in - this should signal a new build of the
  /// timer with the passed in new time and opposite direction.
  ///
  /// Since the timer only rebuilds when being switched, the [switchTimer] flag
  /// will always start false at initialization and become true from the first
  /// user switch up until it is disposed of.
  /// The only flag that will change is the [switchForward] flag each time the
  /// user switches times.
  ///
  /// If the timer finished, the callback uses the [switchTimer] method which
  /// may also pass in the [startTimer] flag. This signals that the timer should
  /// start up immediately to keep the workout going smoothly.
  double checkIfResetTimer(double value) {
    if (widget.switchTimer) {
//      double value;
      if (widget.switchForward) {
        value = 0.0;
      } else {
        value = 1.0;
      }
if(!widget.startTimer)
        _timerPreviouslyRunning = false;


      _currentTime = widget.time;
      _forwardAnimation = widget.switchForward;
//      _controller.value = value;
//      _controller.duration = Duration(seconds: _currentTime);
    }
    return value;
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
    if (controller != null) {
      if (controller.isAnimating) {
        setTimerPreviouslyRunning(false);
        controller.stop(canceled: false);
      } else {
        setTimerPreviouslyRunning(true);
        setupControllerCallback(controller);
      }
    }
  }

  void setupControllerCallback(AnimationController controller) {
    if (!_forwardAnimation) {
      controller.reverse().whenComplete(() {
        if (controller.status == AnimationStatus.dismissed) {
          _preferences.setTimerPreviouslyRunning(true);
          setTime(null);
          setEndValue(null);
          setEndTimeMillis(null);
          if (widget.notifyParentReverseComplete != null) {
            widget.notifyParentReverseComplete();
          }
        }
      }).catchError((error) {
        print('Timer failed animating in reverse: $error');
        startStopTimer(_controller);
      });
    } else {
      controller.forward().whenComplete(() {
        if (controller.status == AnimationStatus.completed) {
          setTimerPreviouslyRunning(true);
          setTime(null);
          setEndValue(null);
          setEndTimeMillis(null);
          if (widget.notifyParentForwardComplete != null) {
            widget.notifyParentForwardComplete();
          }
        }
      }).catchError((error) {
        print('Timer failed animating forward: $error');
        startStopTimer(_controller);
      });
    }
  }

  void handleError(Error error) {
    startStopTimer(_controller);
  }

  /// Resets the timer based on its current status. This method is passed to the
  /// onLongPress event of the circular timer.
  void resetTimer(AnimationController controller) {
    setTimerPreviouslyRunning(false);
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


^^^ BUILD METHODS ^^^


vvv DISPOSE METHODS vvv

  void setSharedPrefsBeforeDispose() {
    setForwardAnimation(_forwardAnimation);
    setEndValue(_controller.value ?? 0.0);
    setEndTimeMillis(DateTime.now().millisecondsSinceEpoch);
    setTime(_currentTime);
  }

^^^ DISPOSE METHODS ^^^
*/
 */
