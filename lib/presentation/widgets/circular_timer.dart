import 'package:crux/backend/blocs/timer/timer_bloc.dart';
import 'package:crux/backend/blocs/timer/timer_state.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:crux/backend/models/timer/timer_direction.dart';
import 'package:crux/utils/timer_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CircularTimer extends StatelessWidget {
  final AnimationController timerController;
  final VoidCallback timerControllerCallback;

  const CircularTimer({
                        @required this.timerController,
                        @required this.timerControllerCallback,
                      });

  @override
  Widget build(BuildContext context) {
    final TimerBloc timerBloc = BlocProvider.of<TimerBloc>(context);

    return BlocBuilder(
      bloc: timerBloc,
      builder: (BuildContext context, TimerState state) {
        if(state is TimerLoading) {
          return loadingScreen();
        } else if(state is TimerLoaded) {
          return GestureDetector(
            onTap: () {
              startStopTimer(state.timer);
            },
            onLongPress: () {
              resetTimer();
            },
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: <Widget>[
                  circularTimer(),
                  timerText(state),
                ],
              ),
            ),
          );
        } else {
          //TODO: figure out if this is what i want
          return loadingScreen();
        }
      },
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
  Widget timerText(TimerLoaded state) {
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
                timerString(state),
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
        /*Empty to help avoid any flickering from quick loads*/
      ],
    );
  }

  String timerString(TimerLoaded state) {
    Duration duration;
    if(state.timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      duration = timerController.duration * (1 - timerController.value);
    } else {
      duration = timerController.duration * timerController.value;
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
  void startStopTimer(Timer timer) {
    if(timerController != null) {
      if(timerController.isAnimating) {
        timerController.stop(canceled: false);
      } else {
        timerControllerCallback();
//        setupControllerCallback(timerController, timer);
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

//  //TODO: make this do more
//  void handleError(Error error) {
//    startStopTimer(timer);
//  }

/*//TODO: STEP 1 - in timer bloc right now
  double determineControllerValue(TimerLoaded state) {
    if (state.timer.previouslyRunning) {
      return valueDifference(state.timer);
    } else {
      return state.timer.controllerValueOnExit;
    }
  }

  /// Finds the difference in time from the saved ending system time and the
  /// current system time and divides that by the starting duration to get the
  /// new value accounting for elapsed time.
  double valueDifference(Timer timer) {
    int currentTimeMillis = DateTime.now().millisecondsSinceEpoch;

    int elapsedDuration = currentTimeMillis - timer.deviceTimeOnExit;

    double timerDurationOnExit =
        timer.controllerValueOnExit * (timer.duration * 1000.0);

    double value;

    /// If animating forward and the calculated value difference is less than 0,
    /// return 0.0 as the value (can't have a negative value).
    /// Else if difference is greater than 1, return 1.
    /// Finally, return calculated value if neither of the above are true.
    if (timer.direction == TimerDirection.CLOCKWISE) {
      value =
          (timerDurationOnExit + elapsedDuration) / (timer.duration * 1000.0);
      if (value <= 0.0) return 0.0;
    } else {
      value =
          (timerDurationOnExit - elapsedDuration) / (timer.duration * 1000.0);
      if (value >= 1) return 1.0;
    }
    return value;
  }*/

  /// Creates an AnimationController based on whether or not the timer should
  /// be animating forward or not. The duration is the rest duration if
  /// forward, or rep duration if reverse. Value is calculated if the timer
  /// was left running or retrieved from memory if stopped.

  //TODO: STEP 2 (???)
/*void setupController(double value, TimerLoaded state) {
    timerController.value = value;
    timerController.duration = Duration(seconds: state.timer.duration);
    if (state.timer.previouslyRunning) {
      setupControllerCallback(timerController, state.timer);
    }
  }

  void setupControllerCallback(AnimationController controller, Timer timer) {
    if (timer.direction == TimerDirection.COUNTERCLOCKWISE) {
      controller.reverse().whenComplete(() {
        //TODO: left off here 6/19 => trying to decide how to handle this. Does exercise pass in callback?
        //TODO: dispatch to timerComplete? dispatch to exercise? need to figure this out
        if (controller.status == AnimationStatus.dismissed) {
          //TODO: 6/26 - thinking about dispatching to both here -> one to create
          //todo: the next timer and one to update set/rep count with the exercise
          timerBloc.dispatch(TimerComplete(timer));
          hangboardExerciseBloc.dispatch(RepComplete());
        }
      }).catchError((error) {
        print('Timer failed animating counterclockwise: $error');
        startStopTimer(controller);
      });
    } else {
      controller.forward().whenComplete(() {
        if (controller.status == AnimationStatus.completed) {
          timerBloc.dispatch(TimerComplete(timer));
          //TODO: 6/26 - Thinking that I only need to dispatch to exercise after
          //todo: rep and rest have completed. if i dispatch here I'm assuming that's the case

          //todo: Random thought but do i want to pass in exercise bloc to make this more generic?

          hangboardExerciseBloc.dispatch(RepComplete());
        }
      }).catchError((error) {
        print('Timer failed animating clockwise: $error');
        startStopTimer(controller);
      });
    }
  }*/
}
