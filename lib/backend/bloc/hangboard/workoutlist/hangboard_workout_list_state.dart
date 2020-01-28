import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout_list.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutListState extends Equatable {
  HangboardWorkoutListState();
}

class HangboardWorkoutListLoadInProgress extends HangboardWorkoutListState {
  @override
  String toString() => 'HangboardListLoadInProgress';

  @override
  List<Object> get props => [];
}

class HangboardWorkoutListLoadSuccess extends HangboardWorkoutListState {
  final HangboardWorkoutList hangboardWorkoutList;

  HangboardWorkoutListLoadSuccess(this.hangboardWorkoutList);

  @override
  String toString() {
    return 'HangboardWorkoutListLoadSuccess: {'
        'hangboardWorkoutList: ${hangboardWorkoutList.toString()}'
        '}';
  }

  @override
  List<Object> get props => [hangboardWorkoutList];
}

class HangboardWorkoutListLoadFailure extends HangboardWorkoutListState {
  @override
  String toString() => 'HangboardWorkoutListLoadFailure';

  @override
  List<Object> get props => [];
}

class HangboardWorkoutListAddWorkoutDuplicate
    extends HangboardWorkoutListState {
  final HangboardWorkout hangboardWorkout;
  final HangboardWorkoutList hangboardWorkoutList;

  HangboardWorkoutListAddWorkoutDuplicate(
      this.hangboardWorkout, this.hangboardWorkoutList);

  @override
  String toString() => 'HangboardWorkoutListAddWorkoutDuplicate';

  @override
  List<Object> get props => [hangboardWorkout, hangboardWorkoutList];
}

class HangboardWorkoutListAddWorkoutSuccess extends HangboardWorkoutListState {
  final HangboardWorkoutList hangboardWorkoutList;

  HangboardWorkoutListAddWorkoutSuccess(this.hangboardWorkoutList);

  @override
  String toString() {
    return 'HangboardWorkoutListAddWorkoutSuccess: {'
        'hangboardWorkoutList: ${hangboardWorkoutList.toString()}'
        '}';
  }

  @override
  List<Object> get props => [hangboardWorkoutList];
}

class HangboardWorkoutListDeleteWorkoutSuccess
    extends HangboardWorkoutListState {
  final HangboardWorkoutList hangboardWorkoutList;

  HangboardWorkoutListDeleteWorkoutSuccess(this.hangboardWorkoutList);

  @override
  String toString() {
    return 'HangboardParentWorkoutDeleted: {'
        'hangboardWorkoutList: ${hangboardWorkoutList.toString()}'
        '}';
  }

  @override
  List<Object> get props => [hangboardWorkoutList];
}
