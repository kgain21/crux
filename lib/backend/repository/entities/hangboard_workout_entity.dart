import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';

class HangboardWorkoutEntity {
  final String workoutTitle;
  final List<HangboardExercise> hangboardExerciseList;

  //TODO: I'm sure there's more that i'll need to add to this
  HangboardWorkoutEntity(this.workoutTitle,
                         this.hangboardExerciseList,);

/*  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExerciseEntity &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;
  */

  Map<String, Object> toJson() {
    return {
      "workoutTitle": workoutTitle,
      "hangboardExerciseList": hangboardExerciseList,
    };
  }

  @override
  String toString() {
    return 'HangboardWorkoutEntity { workoutTitle: $workoutTitle, '
        'hangboardExerciseList: $hangboardExerciseList, '
        '}';
  }

  static HangboardWorkoutEntity fromJson(Map<String, Object> json) {
    return HangboardWorkoutEntity(
      json["workoutTitle"] as String,
      json["hangboardExerciseList"] as List<HangboardExercise>,
    );
  }
}
