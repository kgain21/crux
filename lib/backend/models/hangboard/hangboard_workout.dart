import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';

class HangboardWorkout {
  final String workoutTitle;
  final List<HangboardExercise> hangboardExerciseList;

  HangboardWorkout(this.workoutTitle,
                   this.hangboardExerciseList,);

  Map<String, Object> toJson() {
    return {
      "workoutTitle": workoutTitle,
      "hangboardExerciseList": hangboardExerciseList,
    };
  }

  @override
  String toString() {
    return 'HangboardWorkout { workoutTitle: $workoutTitle, '
        'hangboardExerciseList: $hangboardExerciseList '
        '}';
  }

  static HangboardWorkout fromJson(Map<String, Object> json) {
    return HangboardWorkout(
      json["workoutTitle"] as String,
      json["hangboardExerrciseList"] as List<HangboardExercise>,
    );
  }
}
