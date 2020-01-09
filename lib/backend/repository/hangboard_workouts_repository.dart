import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';

abstract class HangboardWorkoutsRepository {
  Future<List<HangboardExerciseEntity>> getExercisesFromWorkout(
      String workoutTitle);

  Future<HangboardWorkoutEntity> getWorkoutByWorkoutTitle(String workoutTitle);

  Future<void> addExerciseToWorkout(
      String workoutTitle, HangboardExercise hangboardExercise);

  Future<HangboardWorkout> deleteExerciseFromWorkout(
      String workoutTitle, HangboardExercise hangboardExercise);

  Future<List<String>> getWorkoutTitles();

  Future<bool> addNewWorkout(HangboardWorkout hangboardWorkout);

  Future<void> deleteWorkoutByTitle(String hangboardWorkoutTitle);

  Future<void> updateWorkout(HangboardWorkout hangboardWorkout);
}
