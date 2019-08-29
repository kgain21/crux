

class HangboardWorkoutEntity {
  final String workoutTitle;

//  final List<HangboardExercise> hangboardExerciseList;

  //TODO: I'm sure there's more that i'll need to add to this
  HangboardWorkoutEntity(this.workoutTitle,
                         /*this.hangboardExerciseList,*/);

/*  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ExerciseEntity &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;
  */

  Map<String, Object> toJson() {
    return {
      "workoutTitle": workoutTitle,
//      "hangboardExerciseList": hangboardExerciseList,
    };
  }

  @override
  String toString() {
    return 'HangboardWorkoutEntity { workoutTitle: $workoutTitle, '
//        'hangboardExerciseList: $hangboardExerciseList, '
        '}';
  }
//todo: left off here 7/26 - firestore repo get method doesn't match up with current
  //todo: doc structure so I either need to change that or this entity

  //todo: at least adding workoutTitle helped tiles show up, not sure about other error
  //todo: also looks like exercisePageView doesn't have initialized Bloc, maybe try Bloc()..dispatch() like in workouts page
  static HangboardWorkoutEntity fromJson(Map<String, Object> json) {
    return HangboardWorkoutEntity(
        json["workoutTitle"] as String
//      json["hangboardExerciseList"] as List<HangboardExercise>
    );
  }
}
