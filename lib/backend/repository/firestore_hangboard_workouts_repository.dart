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
  static const String HANGBOARD = 'hangboard';

  final Firestore firestore;

  const FirestoreHangboardWorkoutsRepository(this.firestore);

  /// Returns a list of exercises mapped from the given workout
  @override
  Future<List<HangboardExerciseEntity>> getExercisesFromWorkout(
      String workoutTitle) {
    return firestore
        .collection('$HANGBOARD/$workoutTitle')
        .snapshots()
        .map((snapshot) {
          return snapshot.documents.map((doc) {
            return HangboardExerciseEntity.fromJson(doc.data);
          }).toList();
        })
        .first
        .catchError((error) {
          print('Failed retrieving exercises from $workoutTitle: $error');
          return Future.error(error);
        });
  }

  /// Given a workout's title and a new exercise, find the workout in the db and
  /// add the exercise to it.
  ///
  /// Returns a bool signifying whether the exercise was added or not. If the
  /// exercise is already present
  @override
  Future<bool> addExerciseToWorkout(
      String workoutTitle, HangboardExercise hangboardExercise) async {
    final hangboardExerciseEntity = hangboardExercise.toEntity();

    return getWorkoutByWorkoutTitle(workoutTitle)
        .then((hangboardWorkout) async {
      if(hangboardWorkout.hangboardExerciseEntityList
          .any((hangboardExerciseEntity) {
        return hangboardExerciseEntity.exerciseTitle ==
            hangboardExercise.exerciseTitle;
      })) {
        return false;
      }
      hangboardWorkout.hangboardExerciseEntityList.add(hangboardExerciseEntity);
      return await updateWorkout(HangboardWorkout.fromEntity(hangboardWorkout));
    }).catchError((error) {
      print('Failed to retrieve workout for $workoutTitle: $error');
      return Future.error(error);
    });
  }

  /// Deletes an existing exercise from a specified workout.
  ///
  /// First queries the DB for the specific workout, removes the exercise from
  /// the exerciseList, and saves the updated workout back to the DB
  ///
  /// Returns the updated workout
  @override
  Future<HangboardWorkout> deleteExerciseFromWorkout(String workoutTitle,
      HangboardExercise hangboardExercise) async {
    HangboardWorkout hangboardWorkout =
    await getWorkoutByWorkoutTitle(workoutTitle).then((workoutEntity) {
      return HangboardWorkout.fromEntity(workoutEntity);
    }).catchError((error) {
      return null;
    });

    hangboardWorkout.hangboardExerciseList
        .removeWhere((hangboardExerciseEntity) {
      return hangboardExerciseEntity.exerciseTitle ==
          hangboardExercise.exerciseTitle;
    });

    return updateWorkout(hangboardWorkout).then((onSuccess) {
      if(onSuccess) {
        return hangboardWorkout;
      } else {
        return null;
      }
    }).catchError((onError) {
      print(onError);
      return Future.error(onError);
    });
  }

  @override
  Future<List<String>> getWorkoutTitles() async {
    return firestore
        .collection(HANGBOARD)
        .snapshots()
        .first
        .then((hangboardCollection) =>
        hangboardCollection.documents
            .map((workoutDocument) => workoutDocument.documentID)
            .toList())
        .catchError((error) {
      print('Failed retrieving workouts:  $error');
      return Future.error(error);
    });
  }

  @override
  Future<HangboardWorkoutEntity> getWorkoutByWorkoutTitle(
      String workoutTitle) async {
    return firestore
        .collection(HANGBOARD)
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
      final collectionReference = firestore.collection(HANGBOARD);

      workoutRef = collectionReference.document(hangboardWorkout.workoutTitle);

      final doc = await workoutRef.get();
      if(doc.exists)

        /// Can't add this workout name since it already exists. UI alert shown
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
    CollectionReference collectionReference = firestore.collection(HANGBOARD);

    var workoutRef =
    collectionReference.document(hangboardWorkout.workoutTitle);

    return workoutRef.setData(hangboardWorkout.toEntity().toJson()).then((_) {
      return true;
    }).catchError((error) {
      print("Failed updating workout ${hangboardWorkout.workoutTitle}");
      print(error);
      return Future.error(error);
    });
  }

  /// Delete an entire workout and all exercises.
  ///
  /// Returns a boolean to say whether the delete succeeded or not.
  @override
  Future<bool> deleteWorkoutByTitle(String hangboardWorkoutTitle) async {
    return firestore
        .document('$HANGBOARD/$hangboardWorkoutTitle}')
        .delete()
        .then((_) {
      return true;
    }).catchError((error) {
      print("Failed deleting workout $hangboardWorkoutTitle");
      print(error);
      return Future.error(error);
    });
  }
}
