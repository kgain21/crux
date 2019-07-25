import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';

import 'entities/hangboard_exercise_entity.dart';
import 'entities/hangboard_workout_entity.dart';

abstract class HangboardWorkoutsRepository {
  Future<List<HangboardExerciseEntity>> getExercises(String workout);

  Future<void> addNewExercise(HangboardExercise hangboardExercise);

  Future<void> deleteExercise(HangboardExercise hangboardExercise);

  Future<void> updateExercise(HangboardExercise hangboardExercise);

  Future<List<HangboardWorkoutEntity>> getWorkouts();

  Future<bool> addNewWorkout(HangboardWorkout hangboardWorkout);

  Future<void> deleteWorkout(HangboardWorkout hangboardWorkout);

  Future<void> updateWorkout(HangboardWorkout hangboardWorkout);
}
