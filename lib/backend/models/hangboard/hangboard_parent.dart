

class HangboardParent {
  final List<String> hangboardWorkoutList;

  HangboardParent(
    this.hangboardWorkoutList,
  );

  @override
  String toString() {
    return 'HangboardParent { hangboardWorkoutList: $hangboardWorkoutList '
        '}';
  }

/*HangboardParentEntity toEntity() {
    return HangboardParentEntity(
      hangboardWorkoutList.map((workout) => workout.toEntity()).toList(),
    );
  }

  static HangboardParent fromEntity(HangboardParentEntity entity) {
    return HangboardParent(
      entity.hangboardWorkoutEntityList
          .map((workoutEntity) => HangboardWorkout.fromEntity(workoutEntity))
          .toList(),
    );
  }*/
}
