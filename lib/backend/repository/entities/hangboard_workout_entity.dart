
import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hangboard_workout_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class HangboardWorkoutEntity {
  final String workoutTitle;
  final List<HangboardExerciseEntity> hangboardExerciseEntityList;

  HangboardWorkoutEntity(
    this.workoutTitle,
    this.hangboardExerciseEntityList,
  );

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

/*  Map<String, Object> toJson() => {
        "workoutTitle": workoutTitle,
        "hangboardExerciseEntityList": hangboardExerciseEntityList,
//            .map((entity) => entity.toJson()),
      };*/

  @override
  String toString() {
    return 'HangboardWorkoutEntity { workoutTitle: $workoutTitle, '
        'hangboardExerciseList: $hangboardExerciseEntityList '
        '}';
  }

  factory HangboardWorkoutEntity.fromJson(Map<String, dynamic> json) => _$HangboardWorkoutEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HangboardWorkoutEntityToJson(this);

 /* static HangboardWorkoutEntity fromJson(Map<String, dynamic> json) {
    return HangboardWorkoutEntity(
      json["workoutTitle"] as String,
      List<HangboardExerciseEntity>.from(json["hangboardExerciseEntityList"] ??
          [] as List<HangboardExerciseEntity>),
    );
  }*/
}
