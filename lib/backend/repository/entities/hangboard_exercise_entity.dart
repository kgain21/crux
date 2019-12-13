
import 'package:json_annotation/json_annotation.dart';

part 'hangboard_exercise_entity.g.dart';

@JsonSerializable(anyMap: true)
class HangboardExerciseEntity {
  final String exerciseTitle;
  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHands;
  final String holdType; // Formerly hold
  final String fingerConfiguration;
  final double holdDepth; // formerly depth
  final int hangsPerSet;
  final int numberOfSets;
  final int resistance;
  final int breakDuration;
  final int repDuration; // Formerly timeOn
  final int restDuration; // Formerly timeOff

  HangboardExerciseEntity(this.exerciseTitle,
                          this.depthMeasurementSystem,
                          this.resistanceMeasurementSystem,
                          this.numberOfHands,
                          this.holdType,
                          this.fingerConfiguration,
                          this.holdDepth,
                          this.hangsPerSet,
                          this.numberOfSets,
                          this.resistance,
                          this.breakDuration,
                          this.repDuration,
                          this.restDuration);

  @override
  int get hashCode =>
      exerciseTitle.hashCode ^
      depthMeasurementSystem.hashCode ^
      resistanceMeasurementSystem.hashCode ^
      numberOfHands.hashCode ^
      holdType.hashCode ^
      fingerConfiguration.hashCode ^
      holdDepth.hashCode ^
      hangsPerSet.hashCode ^
      numberOfSets.hashCode ^
      resistance.hashCode ^
      breakDuration.hashCode ^
      repDuration.hashCode ^
      restDuration.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HangboardExerciseEntity &&
              runtimeType == other.runtimeType &&
              exerciseTitle == other.exerciseTitle &&
              depthMeasurementSystem == other.depthMeasurementSystem &&
              resistanceMeasurementSystem ==
                  other.resistanceMeasurementSystem &&
              numberOfHands == other.numberOfHands &&
              holdType == other.holdType &&
              fingerConfiguration == other.fingerConfiguration &&
              holdDepth == other.holdDepth &&
              hangsPerSet == other.hangsPerSet &&
              numberOfSets == other.numberOfSets &&
              resistance == other.resistance &&
              breakDuration == other.breakDuration &&
              repDuration == other.repDuration &&
              restDuration == other.restDuration;

  Map<String, dynamic> toJson() => _$HangboardExerciseEntityToJson(this);

  factory HangboardExerciseEntity.fromJson(Map json) =>
      _$HangboardExerciseEntityFromJson(json);

  @override
  String toString() {
    return 'HangboardExerciseEntity { exerciseTitle: $exerciseTitle, '
        'depthMeasurementSystem: $depthMeasurementSystem, '
        'resistanceMeasurementSystem: $resistanceMeasurementSystem, '
        'numberOfHands: $numberOfHands, '
        'holdType: $holdType,'
        'fingerConfiguration: $fingerConfiguration, '
        'holdDepth: $holdDepth, '
        'hangsPerSet: $hangsPerSet, '
        'numberOfSets: $numberOfSets, '
        'resistance: $resistance, '
        'breakDuration: $breakDuration, '
        'repDuration: $repDuration, '
        'restDuration: $restDuration '
        '}';
  }
}
