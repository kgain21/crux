import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';

class HangboardWorkout {
  final String workoutTitle;
  final List<HangboardExercise> hangboardExerciseList;

  HangboardWorkout(this.workoutTitle,
                   this.hangboardExerciseList,);

  @override
  String toString() {
    return 'HangboardWorkout { workoutTitle: $workoutTitle, '
        'hangboardExerciseList: $hangboardExerciseList '
        '}';
  }

  HangboardWorkoutEntity toEntity() {
    return HangboardWorkoutEntity(
      workoutTitle,
      hangboardExerciseList,
    );
  }

  static HangboardWorkout fromEntity(HangboardWorkoutEntity entity) {
    return HangboardWorkout(
      entity.workoutTitle,
      entity.hangboardExerciseList,
    );
  }
}
