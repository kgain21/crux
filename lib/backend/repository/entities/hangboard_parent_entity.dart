import 'package:crux/backend/models/hangboard/hangboard_workout.dart';

class HangboardParentEntity {
  final List<HangboardWorkout> hangboardWorkoutList;

  HangboardParentEntity(
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
      "hangboardWorkoutList": hangboardWorkoutList,
    };
  }

  @override
  String toString() {
    return 'HangboardParentEntity { hangboardWorkoutList: $hangboardWorkoutList, '
        '}';
  }

  static HangboardParentEntity fromJson(Map<String, Object> json) {
    return HangboardParentEntity(
      json["hangboardWorkoutList"] as List<HangboardWorkout>,
    );
  }
}
