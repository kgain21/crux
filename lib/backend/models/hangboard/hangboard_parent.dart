import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_parent_entity.dart';

class HangboardParent {
  final String workoutTitle;
  final List<HangboardWorkout> hangboardWorkoutList;

  HangboardParent(
    this.workoutTitle,
    this.hangboardWorkoutList,
  );

  @override
  String toString() {
    return 'HangboardParent { workoutTitle: $workoutTitle, '
        'hangboardWorkoutList: $hangboardWorkoutList '
        '}';
  }

  HangboardParentEntity toEntity() {
    return HangboardParentEntity(
      workoutTitle,
      hangboardWorkoutList,
    );
  }

  static HangboardParent fromEntity(HangboardParentEntity entity) {
    return HangboardParent(
      entity.workoutTitle,
      entity.hangboardWorkoutList,
    );
  }
}
