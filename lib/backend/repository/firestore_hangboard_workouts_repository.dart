import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';

class FirestoreHangboardWorkoutsRepository
    implements HangboardWorkoutsRepository {
  //todo: make this an enum
  static const String workoutType = 'hangboard';

  final Firestore firestore;

  const FirestoreHangboardWorkoutsRepository(this.firestore);

  /// Returns a list of exercises mapped from the given workout
  @override
  Future<List<HangboardExerciseEntity>> getExercises(String workoutTitle) {
    return firestore
        .collection('$workoutType/$workoutTitle')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return HangboardExerciseEntity.fromJson(doc.data);
      }).toList();
    }).first;
  }

  @override
  Future<void> addNewExercise(HangboardExercise hangboardExercise) {
    final hangboardExerciseEntity = hangboardExercise.toEntity();
    return firestore
        .collection(workoutType)
        .add(hangboardExerciseEntity.toJson());
  }

  @override
  Future<void> updateExercise(HangboardExercise hangboardExercise) {
    /*//todo: should I have a get method that the ui calls and then decides to add or update?
    //Todo: dispatch to add/update event and have it decide in the bloc?
    String hangboardExerciseId = createHangboardExerciseId(hangboardExercise);
    var exerciseRef = firestore.collection(workoutType).document(hangboardExerciseId);
    exerciseRef.get().then((doc) {
      if (doc.exists) {
        _exerciseExistsAlert(scaffoldContext, exerciseRef, data);
      } else {
        exerciseRef.setData(hangboardExercise.toJson());
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
    return firestore.collection(workoutType)(hangboardExercise.toJson());*/
    return null;
  }

  @override
  Future<void> deleteExercise(HangboardExercise hangboardExercise) {
    return null;
//    return firestore.collection(workoutType).document(id).delete();
  }

  @override
  Future<List<HangboardWorkoutEntity>> getWorkouts() async {
    return firestore
        .collection(workoutType)
        .snapshots()
        .first
        .then((hangboardCollection) {
      return hangboardCollection.documents.map((workoutDocument) {
        return HangboardWorkoutEntity.fromJson(workoutDocument.data);
      }).toList();
    });
  }

/*

        //todo: 8/21- reworking db, trying to send stream back to ui for dynamic updating-0

        HangboardWorkoutEntity createHangboardWorkoutEntity(DocumentSnapshot
        workout,
        QuerySnapshot exercises)
    {
      return HangboardWorkoutEntity.fromData(
          workout.data,
          exercises.documents.map((exercise) {
            HangboardExercise.fromEntity(
                HangboardExerciseEntity.fromJson(exercise.data));
          }).toList());
    }
*/

  @override
  Future<bool> addNewWorkout(HangboardWorkout hangboardWorkout) async {
    var workoutRef;
    final hangboardWorkoutEntity = hangboardWorkout.toEntity();
    try {
      final collectionReference = firestore.collection(workoutType);

      workoutRef = collectionReference.document(hangboardWorkout.workoutTitle);

      final doc = await workoutRef.get();
      if (doc.exists)
        // Can't add this workout name since it already exists. UI alert shown
        return false;
      else {
        workoutRef.setData(hangboardWorkoutEntity.toJson());
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> updateWorkout(HangboardWorkout hangboardWorkout) async {
    final hangboardWorkoutEntity = hangboardWorkout.toEntity();

    try {
      CollectionReference collectionReference =
          firestore.collection(workoutType);

      var workoutRef =
          collectionReference.document(hangboardWorkout.workoutTitle);
      workoutRef.setData(hangboardWorkoutEntity.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<void> deleteWorkout(HangboardWorkout hangboardWorkout) {
    final hangboardWorkoutEntity = hangboardWorkout.toEntity();

    return firestore.collection(workoutType).getDocuments().then((snapshot) {
      snapshot.documents.forEach((document) => document.reference.delete());
      firestore
          .document('$workoutType/${hangboardWorkoutEntity.workoutTitle}')
          .delete();
    });
  }
}
