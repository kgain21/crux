import 'package:crux/backend/bloc/timer/timer_state.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/utils/timer_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircularTimer extends StatelessWidget {
  final AnimationController timerController;
  final VoidCallback timerControllerCallback;
  final TimerLoadSuccess timerState;

  const CircularTimer({
    @required this.timerController,
    @required this.timerControllerCallback,
    @required this.timerState,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        startStopTimer();
      },
      onLongPress: () {
        resetTimer();
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
        animation: timerController,
        builder: (context, child) {
          return CustomPaint(
            painter: TimerPainter(
              animation: timerController,
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
                      .primaryColorLight,
                ),
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
            animation: timerController,
            builder: (context, child) {
              return Text(
                timerString(),
                style: TextStyle(
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .width / 7.0,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  String timerString() {
    Duration duration;
    if(timerState.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      duration = timerController.reverseDuration * timerController.value;
    } else {
      duration = timerController.duration * (1 - timerController.value);
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0')}';
  }

  /// Controls starting or stopping the [timerController] and determines which
  /// way it should animate using the boolean [_forwardAnimation], where true is
  /// forward and false is reverse. This method is passed to the onClickEvent
  /// of the [WorkoutTimer].
  ///
  /// When the animation completes, a notification is sent to the parent
  /// [WorkoutScreen] widget to tell it that it has finished.
  ///
  /// Additionally, the [SharedPreferences] get nulled out so that future timers
  /// don't try to read old values.
  void startStopTimer() {
    if(timerController != null) {
      if(timerController.isAnimating) {
        timerController.stop(canceled: false);
      } else {
        timerControllerCallback();
      }
    }
  }

  /// Resets the timer based on its current status. This method is passed to the
  /// onLongPress event of the circular timer.
  void resetTimer() {
    if(timerController.isAnimating) {
      timerController.stop(canceled: false);
      if(timerController.status == AnimationStatus.reverse) {
        timerController.value = 1.0;
      } else if(timerController.status == AnimationStatus.forward) {
        timerController.value = 0.0;
      }
    } else {
      if(timerController.status == AnimationStatus.reverse) {
        timerController.value = 1.0;
      } else if(timerController.status == AnimationStatus.forward) {
        timerController.value = 0.0;
      }
    }
  }
}
