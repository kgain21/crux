import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';

import 'hangboard_exercise.dart';

class HangboardWorkout {
  final String workoutTitle;

  final List<HangboardExercise> hangboardExerciseList;

  HangboardWorkout(
    this.workoutTitle,
    this.hangboardExerciseList,
  );

  @override
  String toString() {
    return 'HangboardWorkout { workoutTitle: $workoutTitle, '
        'hangboardExerciseList: $hangboardExerciseList '
        '}';
  }

  HangboardWorkoutEntity toEntity() {
    return HangboardWorkoutEntity(
      workoutTitle,
      hangboardExerciseList.map((exercise) => exercise.toEntity()).toList(),
    );
  }

  static HangboardWorkout fromEntity(HangboardWorkoutEntity entity) {
    return HangboardWorkout(
      entity.workoutTitle,
      entity.hangboardExerciseEntityList
          .map((entity) => HangboardExercise.fromEntity(entity)).toList(),
    );
  }
}
