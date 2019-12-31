import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/services/repository_stream_listener.dart';

class FirestoreStreamListener implements RepositoryStreamListener {
  static const REPOSITORY_COLLECTION_PATH = 'hangboard';

  StreamSubscription streamSubscription;

  FirestoreStreamListener() {
    streamSubscription = Firestore.instance
        .collection(REPOSITORY_COLLECTION_PATH)
        .snapshots()
        .listen((querySnapshot) {
//      onUpdate(querySnapshot);
      return querySnapshot.documents
          .map((workoutDocument) => HangboardWorkout.fromEntity(
              HangboardWorkoutEntity.fromJson(workoutDocument.data)))
          .toList();
    });
  }

  @override
  void dispose() {
    streamSubscription.cancel();
  }
}
