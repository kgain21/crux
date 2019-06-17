import 'entities/hangboard_exercise_entity.dart';
import 'entities/hangboard_workout_entity.dart';

abstract class HangboardWorkoutsRepository {
  Stream<List<HangboardExerciseEntity>> exercises(String workoutPath);

  Future<void> addNewExercise(HangboardExerciseEntity exerciseEntity);

  Future<void> deleteExercise(HangboardExerciseEntity exerciseEntity);

  Future<void> updateExercise(HangboardExerciseEntity exerciseEntity);

  Stream<List<HangboardWorkoutEntity>> workouts();

  Future<void> addNewWorkout(HangboardWorkoutEntity workoutEntity);

  Future<void> deleteWorkout(HangboardWorkoutEntity workoutEntity);

  Future<void> updateWorkout(HangboardWorkoutEntity workoutEntity);
}
