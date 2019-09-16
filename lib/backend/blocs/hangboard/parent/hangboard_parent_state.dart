import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardParentState extends Equatable {
  HangboardParentState([List props = const []]) : super(props);
}

class HangboardParentLoading extends HangboardParentState {
  @override
  String toString() => 'HangboardParentLoading';
}

class HangboardParentLoaded extends HangboardParentState {
  final HangboardParent hangboardParent;

  HangboardParentLoaded(this.hangboardParent,) : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentLoaded: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}

class HangboardParentNotLoaded extends HangboardParentState {
  @override
  String toString() => 'HangboardParentNotLoaded';
}

class HangboardParentDuplicateWorkout extends HangboardParentState {
  final HangboardWorkout hangboardWorkout;
  final HangboardParent hangboardParent;

  HangboardParentDuplicateWorkout(this.hangboardWorkout,
                                  this.hangboardParent,)
      : super([hangboardWorkout, hangboardParent]);

  @override
  String toString() => 'HangboardParentDuplicateWorkout';
}

class HangboardParentWorkoutAdded extends HangboardParentState {
  final HangboardParent hangboardParent;

  HangboardParentWorkoutAdded(this.hangboardParent,) : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentWorkoutAdded: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}

class HangboardParentWorkoutDeleted extends HangboardParentState {
  final HangboardParent hangboardParent;

  HangboardParentWorkoutDeleted(this.hangboardParent,)
      : super([hangboardParent]);

  @override
  String toString() {
    return 'HangboardParentWorkoutDeleted: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}
