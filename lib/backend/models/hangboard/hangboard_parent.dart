import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_parent_entity.dart';

class HangboardParent {
  final List<HangboardWorkout> hangboardWorkoutList;

  HangboardParent(
    this.hangboardWorkoutList,
  );

  @override
  String toString() {
    return 'HangboardParent { hangboardWorkoutList: $hangboardWorkoutList '
        '}';
  }

  HangboardParentEntity toEntity() {
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
  }
}
