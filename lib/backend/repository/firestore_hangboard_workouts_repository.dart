import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';

import 'hangboard_workouts_repository.dart';

class FirestoreHangboardWorkoutsRepository
    implements HangboardWorkoutsRepository {
  //todo: make this an enum
  static const String workoutType = 'hangboard';

  final Firestore firestore;

  const FirestoreHangboardWorkoutsRepository(this.firestore);

  /*@override
  Future<void> addNewTodo(HangboardExerciseEntity todo) {
    return firestore.collection(workoutType).document(todo.id).setData(todo.toJson());
  }

  @override
  Future<void> deleteTodo(List<String> idList) async {
    await Future.wait<void>(idList.map((id) {
      return firestore.collection(workoutType).document(id).delete();
    }));
  }

  @override
  Future<void> updateTodo(HangboardExerciseEntity exercise) {
    return firestore
        .collection(workoutType)
        .document(exercise..id)
        .updateData(todo.toJson());
  }*/

  /// Returns a list of exercises mapped from the given workout
  @override
  Stream<List<HangboardExerciseEntity>> getExercises(String workoutTitle) {
    return firestore.collection('$workoutType/$workoutTitle')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return HangboardExerciseEntity.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Future<void> addNewExercise(HangboardExerciseEntity exerciseEntity) {
    return firestore.collection(workoutType)
        .add(exerciseEntity.toJson());
  }

  @override
  Future<void> updateExercise(HangboardExerciseEntity exerciseEntity) {
    /*//todo: should I have a get method that the ui calls and then decides to add or update?
    //Todo: dispatch to add/update event and have it decide in the bloc?
    String hangboardExerciseId = createHangboardExerciseId(exerciseEntity);
    var exerciseRef = firestore.collection(workoutType).document(hangboardExerciseId);
    exerciseRef.get().then((doc) {
      if (doc.exists) {
        _exerciseExistsAlert(scaffoldContext, exerciseRef, data);
      } else {
        exerciseRef.setData(exerciseEntity.toJson());
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
    return firestore.collection(workoutType)(exerciseEntity.toJson());*/
    return null;
  }

  @override
  Future<void> deleteExercise(HangboardExerciseEntity exerciseEntity) {
    return null;
//    return firestore.collection(workoutType).document(id).delete();
  }

  @override
  Stream<List<HangboardWorkoutEntity>> getWorkouts() {
    return firestore.collection(workoutType)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) {
        return HangboardWorkoutEntity.fromJson(doc.data);
      }).toList();
    });
  }

  @override
  Future<void> deleteWorkout(HangboardWorkoutEntity workoutEntity) {
    return firestore.collection(workoutType)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents
          .forEach((document) => document.reference.delete());
      firestore
          .document('$workoutType/${workoutEntity.workoutTitle}')
          .delete();
    });
  }

  /// Currently doing an update if there, create if not with this method
  @override
  Future<void> updateWorkout(HangboardWorkoutEntity workoutEntity) {
    CollectionReference collectionReference =
    firestore.collection(workoutType);

    var workoutRef = collectionReference.document(workoutEntity.workoutTitle);
    workoutRef.get().then((doc) {
      if(doc.exists) {
        _exerciseExistsAlert(scaffoldContext, workoutTitle);
      } else {
        workoutRef.setData(Map());
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
  }


  @override
  Future<bool> addNewWorkout(HangboardWorkoutEntity workoutEntity) async {
    CollectionReference collectionReference = firestore.collection(workoutType);

    var workoutRef = collectionReference.document(workoutEntity.workoutTitle);
    workoutRef
        .get()
        .then((doc) {
      if(doc.exists)
        return false;
      else {
        workoutRef.setData(workoutEntity.toJson());
        return true;
      }
      //todo: workouts. Should add try/catch and logging to firestore calls throughout
    };
    }
}
