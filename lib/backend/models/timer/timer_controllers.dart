import 'package:crux/backend/bloc/timer/timer_bloc.dart';
import 'package:crux/backend/bloc/timer/timer_event.dart';
import 'package:crux/backend/models/timer/timer.dart';
import 'package:flutter/widgets.dart';

abstract class TimerController {
  void start();
}

class RepAnimationController extends AnimationController
    implements TimerController {
  final TimerBloc timerBloc;
  final Timer timer;

  RepAnimationController(this.timerBloc, this.timer);

  @override
  String toString() =>
      'RepAnimationController duration: ${this.duration}, value: ${this.value}';

  @override
  void start() {
    this.reverse(from: this.value).whenComplete(() {
      if (this.status == AnimationStatus.dismissed) {
        //TODO: 6/26 - thinking about dispatching to both here -> one to create
        //todo: the next timer and one to update set/rep count with the exercise
        timerBloc.add(TimerCompleted(timer));
//        hangboardExerciseBloc.add(RepComplete());
      }
    }).catchError((error) {
      print('Timer failed animating counterclockwise: $error');
//      startStopTimer(controller);
    });
  }
}

class RestAnimationController extends AnimationController {
  @override
  String toString() =>
      'RestAnimationController duration: ${this.duration}, value: ${this.value}';
}

class BreakAnimationController extends AnimationController {
  @override
  String toString() =>
      'BreakAnimationController duration: ${this.duration}, value: ${this.value}';
}
