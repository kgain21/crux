import 'package:json_annotation/json_annotation.dart';

import 'hangboard_workout_entity.dart';

part 'hangboard_parent_entity.g.dart';

@JsonSerializable()
class HangboardParentEntity {
  final List<HangboardWorkoutEntity> hangboardWorkoutEntityList;

  HangboardParentEntity(
    this.hangboardWorkoutEntityList,
  );

/*  @override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WorkoutEntity &&
              runtimeType == other.runtimeType &&
              complete == other.complete &&
              task == other.task &&
              note == other.note &&
              id == other.id;
  */

  /*Map<String, Object> toJson() {
    return {
      "hangboardWorkoutList": hangboardWorkoutList,
    };
  }*/

  factory HangboardParentEntity.fromJson(Map<String, dynamic> json) => _$HangboardParentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$HangboardParentEntityToJson(this);


  @override
  String toString() {
    return 'HangboardParentEntity { hangboardWorkoutEntityList: $hangboardWorkoutEntityList, '
        '}';
  }

/*static HangboardParentEntity fromJson(Map<String, Object> json) {
    return HangboardParentEntity(
      json["hangboardWorkoutList"] as List<HangboardWorkout>,
    );
  }*/
}
