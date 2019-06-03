import 'entities/exercise_entity.dart';
import 'entities/workout_entity.dart';

abstract class HangboardWorkoutsRepository {
  Stream<List<ExerciseEntity>> exercises(String workoutPath);

  Future<void> addNewExercise(ExerciseEntity exerciseEntity);

  Future<void> deleteExercise(ExerciseEntity exerciseEntity);

  Future<void> updateExercise(ExerciseEntity exerciseEntity);

  Stream<List<WorkoutEntity>> workouts();

  Future<void> addNewWorkout(WorkoutEntity workoutEntity);

  Future<void> deleteWorkout(WorkoutEntity workoutEntity);

  Future<void> updateWorkout(WorkoutEntity workoutEntity);
}
