import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout_list.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutListEvent extends Equatable {
  HangboardWorkoutListEvent();
}

class HangboardWorkoutListLoaded extends HangboardWorkoutListEvent {
  @override
  String toString() => 'HangboardWorkoutListLoaded';

  @override
  List<Object> get props => [];
}

class HangboardWorkoutListAdded extends HangboardWorkoutListEvent {
  final HangboardWorkoutList hangboardWorkoutList;

  HangboardWorkoutListAdded(this.hangboardWorkoutList);

  @override
  String toString() =>
      'AddHangboardParent { hangboardParent: $hangboardWorkoutList }';

  @override
  List<Object> get props => [hangboardWorkoutList];
}

class HangboardWorkoutListWorkoutAdded extends HangboardWorkoutListEvent {
  final HangboardWorkoutList hangboardWorkoutList;
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutListWorkoutAdded(
      this.hangboardWorkoutList, this.hangboardWorkout);

  @override
  String toString() => '''HangboardWorkoutListWorkoutAdded { 
        hangboardWorkoutList: $hangboardWorkoutList,
        hangboardWorkout: $hangboardWorkout 
      }''';

  @override
  List<Object> get props => [hangboardWorkoutList, hangboardWorkout];
}

class HangboardWorkoutListWorkoutDeleted extends HangboardWorkoutListEvent {
  final String hangboardWorkoutTitle;

  HangboardWorkoutListWorkoutDeleted(this.hangboardWorkoutTitle);

  @override
  String toString() {
    return '''HangboardWorkoutListWorkoutDeleted: {
          hangboardWorkoutTitle: ${hangboardWorkoutTitle.toString()}
        }''';
  }

  @override
  List<Object> get props => [hangboardWorkoutTitle];
}
