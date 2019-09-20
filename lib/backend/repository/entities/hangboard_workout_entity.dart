import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';

class HangboardWorkoutEntity {
  final String workoutTitle;
  final List<dynamic> hangboardExerciseList;

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
        'hangboardExerciseList: $hangboardExerciseList '
        '}';
  }

  static HangboardWorkoutEntity fromJson(Map<String, dynamic> json) {
    return HangboardWorkoutEntity(
        json["workoutTitle"] as String,
        List<HangboardExercise>.from(json["hangboardExerciseList"]));
    //todo: may need to revisit this - works for now passing [] at workout creation but may not after exercises have been populated

  }
}
