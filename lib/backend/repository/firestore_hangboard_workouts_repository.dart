import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';

import 'hangboard_workouts_repository.dart';

class FirestoreHangboardWorkoutsRepository
    implements HangboardWorkoutsRepository {
  static const String path = 'hangboard';

  final Firestore firestore;

  const FirestoreHangboardWorkoutsRepository(this.firestore);

  @override
  Future<void> addNewTodo(HangboardExerciseEntity todo) {
    return firestore.collection(path).document(todo.id).setData(todo.toJson());
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(path).document(id).delete();
    }));
  }

  @override
  Future<void> updateTodo(HangboardExerciseEntity exercise) {
    return firestore
        .collection(path)
        .document(exercise..id)
        .updateData(todo.toJson());
  }

  @override
  Stream<List<HangboardExerciseEntity>> exercises(String workoutPath) {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return HangboardExerciseEntity.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Future<void> addNewExercise(HangboardExerciseEntity exerciseEntity) {
    return firestore.collection(path).add(exerciseEntity.toJson());
  }

  @override
  Future<void> updateExercise(HangboardExerciseEntity exerciseEntity) {
    //todo: should I have a get method that the ui calls and then decides to add or update?
    //Todo: dispatch to add/update event and have it decide in the bloc?
    String hangboardExerciseId = createHangboardExerciseId(exerciseEntity);
    var exerciseRef = firestore.collection(path).document(hangboardExerciseId);
    exerciseRef.get().then((doc) {
      if(doc.exists) {
        _exerciseExistsAlert(scaffoldContext, exerciseRef, data);
      } else {
        exerciseRef.setData(exerciseEntity.toJson());
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
    return firestore.collection(path)(exerciseEntity.toJson());
  }

  @override
  Future<void> deleteExercise(HangboardExerciseEntity exerciseEntity) async {
    // TODO: implement deleteExercise
  }

  @override
  Stream<List<HangboardWorkoutEntity>> workouts() {
    return firestore.collection(path).snapshots().map((snapshot) {
      return snapshot.documents.map((doc) {
        return HangboardWorkoutEntity.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Future<void> deleteWorkout(HangboardWorkoutEntity workoutEntity) async {
    // TODO: implement deleteWorkout
  }

  @override
  Future<void> addWorkout(HangboardWorkoutEntity workoutEntity) {
    // TODO: implement addWorkout
    return null;
  }

  @override
  Future<void> updateWorkout(HangboardWorkoutEntity workoutEntity) {
    // TODO: implement updateWorkout
    return null;
  }

  String createHangboardExerciseId(
      HangboardExerciseEntity hangboardExerciseEntity) {
    String exerciseId =
        '${hangboardExerciseEntity.numberOfHands.toString()} handed';

    if(hangboardExerciseEntity.holdDepth == null) {
      if(hangboardExerciseEntity.fingerConfiguration == null ||
          hangboardExerciseEntity.fingerConfiguration == '') {
        exerciseId += ' ${hangboardExerciseEntity.holdType}';
      } else {
        exerciseId +=
        ' ${hangboardExerciseEntity
            .fingerConfiguration} ${hangboardExerciseEntity.holdType}';
      }
    } else {
      exerciseId +=
      ' ${hangboardExerciseEntity.holdDepth}${hangboardExerciseEntity
          .depthMeasurementSystem} ${hangboardExerciseEntity
          .fingerConfiguration} ${hangboardExerciseEntity.holdType}';
    }
    return exerciseId;
  }
}
