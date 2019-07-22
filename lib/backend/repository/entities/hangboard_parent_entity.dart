import 'package:crux/backend/models/hangboard/hangboard_workout.dart';

class HangboardParentEntity {
  final String workoutTitle;
  final List<HangboardWorkout> hangboardWorkoutList;

  //TODO: I'm sure there's more that i'll need to add to this
  HangboardParentEntity(
    this.workoutTitle,
    this.hangboardWorkoutList,
  );

/*  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WorkoutEntity &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;
  */

  Map<String, Object> toJson() {
    return {
      "workoutTitle": workoutTitle,
      "hangboardWorkoutList": hangboardWorkoutList,
    };
  }

  @override
  String toString() {
    return 'HangboardParentEntity { workoutTitle: $workoutTitle, '
        'hangboardWorkoutList: $hangboardWorkoutList, '
        '}';
  }

  static HangboardParentEntity fromJson(Map<String, Object> json) {
    return HangboardParentEntity(
      json["workoutTitle"] as String,
      json["hangboardWorkoutList"] as List<HangboardWorkout>,
    );
  }
}
