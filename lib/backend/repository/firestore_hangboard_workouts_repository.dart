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
    }).first
        .catchError((error) {
      print('Failed retrieving exercises from $workoutTitle: $error');
      return Future.error(error);
    });
  }

  /// Given a workout's title and a new exercise, find the workout in the db and
  /// add the exercise to it.
  @override
  Future<bool> addNewExercise(
      String workoutTitle, HangboardExercise hangboardExercise) async {
    final hangboardExerciseEntity = hangboardExercise.toEntity();

    getWorkoutByWorkoutTitle(workoutTitle).then((hangboardWorkout) {
      if(hangboardWorkout.hangboardExerciseEntityList.contains(
          hangboardExerciseEntity)) {
        return false;
      }
      hangboardWorkout.hangboardExerciseEntityList.add(hangboardExerciseEntity);
      return updateWorkout(HangboardWorkout.fromEntity(hangboardWorkout));
    }).catchError((error) {
      print('Failed to retrieve workout for $workoutTitle: $error');
      return Future.error(error);
    });
    return false;

    /*return firestore
        .collection(
            '$workoutType/$workoutTitle/${hangboardExercise.exerciseTitle}')
        .add(hangboardExerciseEntity.toJson());*/
  }

  @override
  Future<void> updateExercise(HangboardExercise hangboardExercise) {
    /*
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
  Future<List<HangboardWorkout>> getWorkouts() async {
    return firestore
        .collection(workoutType)
        .snapshots()
        .first
        .then((hangboardCollection) => hangboardCollection.documents
            .map((workoutDocument) => HangboardWorkout.fromEntity(
                HangboardWorkoutEntity.fromJson(workoutDocument.data)))
            .toList())
        .catchError((error) {
      print('Failed retrieving workouts:  $error');
      return Future.error(error);
    });
  }

  /*Future<HangboardParent> getHangboardParent() async {
    return firestore
        .collection(workoutType)
        .snapshots()
        .first
        .then((hangboardCollection) => HangboardParent.fromEntity(
        HangboardParentEntity.fromJson(hangboardCollection.documents)));
  }*/

  @override
  Future<HangboardWorkoutEntity> getWorkoutByWorkoutTitle(
      String workoutTitle) async {
    return firestore
        .collection(workoutType)
        .snapshots()
        .first
        .then((hangboardCollection) {
      return HangboardWorkoutEntity.fromJson(hangboardCollection.documents
          .firstWhere((document) => workoutTitle == document.documentID,
          orElse: () => null)
          .data);
    }).catchError((error) {
      print('Failed to retrieve workout by title: $error');
      return Future.error(error);
    });
  }

  /// Adds a new workout. This method also checks to see if the workout being
  /// added is a duplicate entry in the db.
  ///
  /// Returns a boolean to say whether the add was a duplicate or not.
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
    } catch(error) {
      print('Failed to add new workout: $error');
      return Future.error(error);
    }
  }

  /// Updates a workout given a workout. This method assumes that the workout
  /// has been retrieved prior to update.
  ///
  /// Returns a boolean to say whether the update succeeded or not.
  @override
  Future<bool> updateWorkout(HangboardWorkout hangboardWorkout) async {
    CollectionReference collectionReference = firestore.collection(workoutType);

    var workoutRef =
    collectionReference.document(hangboardWorkout.workoutTitle);

    workoutRef.setData(hangboardWorkout.toEntity().toJson()).then((_) {
      return true;
    }).catchError((error) {
      print("Failed updating workout ${hangboardWorkout.workoutTitle}");
      print(error);
      return Future.error(error);
    });
    return false;
  }

  /// Delete an entire workout and all exercises.
  ///
  /// Returns a boolean to say whether the delete succeeded or not.
  @override
  Future<bool> deleteWorkout(HangboardWorkout hangboardWorkout) async {
    final hangboardWorkoutEntity = hangboardWorkout.toEntity();

    firestore.collection(workoutType).getDocuments().then((snapshot) {
      firestore
          .document('$workoutType/${hangboardWorkoutEntity.workoutTitle}')
          .delete()
          .then((_) {
        return true;
      }).catchError((error) {
        print("Failed deleting workout ${hangboardWorkoutEntity.workoutTitle}");
        print(error);
        return Future.error(error);
      });
    }).catchError((error) {
      print(
          "Failed retrieving documents on delete of ${hangboardWorkoutEntity
              .workoutTitle}");
      print(error);
      return Future.error(error);
    });
    return false;
  }
}
