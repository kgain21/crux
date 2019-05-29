import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/entities/exercise_entity.dart';
import 'package:crux/backend/repository/entities/workout_entity.dart';

import 'hangboard_workouts_repository.dart';

class FirestoreHangboardWorkoutsRepository
    implements HangboardWorkoutsRepository {
  static const String path = 'hangboard';

  final Firestore firestore;

  const FirestoreHangboardWorkoutsRepository(this.firestore);

  @override
  Future<void> addNewTodo(TodoEntity todo) {
    return firestore.collection(path).document(todo.id).setData(todo.toJson());
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Future<void> updateTodo(TodoEntity todo) {
    return firestore
        .collection(path)
        .document(todo.id)
        .updateData(todo.toJson());
  }

  @override
  Stream<List<ExerciseEntity>> exercises(String workoutPath) {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return ExerciseEntity(/*TODO figure this entity out*/);
      }).toList();
    });
  }

  @override
  Future<void> addExercise(ExerciseEntity exerciseEntity) {
    // TODO: implement addExercise
    return null;
  }

  @override
  Future<void> updateExercise(ExerciseEntity exerciseEntity) {
    // TODO: implement updateExercise
    return null;
  }

  @override
  Future<void> deleteExercise(ExerciseEntity exerciseEntity) async {
    // TODO: implement deleteExercise
  }

  @override
  Stream<List<WorkoutEntity>> workouts() {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return WorkoutEntity(/*TODO figure this entity out*/);
      }).toList();
    });
  }

  @override
  Future<void> deleteWorkout(WorkoutEntity workoutEntity) async {
    // TODO: implement deleteWorkout
  }

  @override
  Future<void> addWorkout(WorkoutEntity workoutEntity) {
    // TODO: implement addWorkout
    return null;
  }

  @override
  Future<void> updateWorkout(WorkoutEntity workoutEntity) {
    // TODO: implement updateWorkout
    return null;
  }
}
