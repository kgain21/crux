import 'package:crux/backend/repository/entities/hangboard_exercise_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class HangboardExercise extends Equatable {
  final String exerciseTitle;
  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHands;
  final String holdType;
  final String fingerConfiguration;
  final double holdDepth;
  final int hangsPerSet;
  final int numberOfSets;
  final int resistance;
  final int breakDuration;
  final int repDuration;
  final int restDuration;

  HangboardExercise(
    this.exerciseTitle,
    this.depthMeasurementSystem,
    this.resistanceMeasurementSystem,
    this.numberOfHands,
    this.holdType,
    this.holdDepth,
    this.hangsPerSet,
    this.numberOfSets,
    this.repDuration,
    this.restDuration, {
    this.fingerConfiguration,
    this.breakDuration,
    this.resistance,
  });

  HangboardExercise copyWith({
    String exerciseTitle,
    String depthMeasurementSystem,
    String resistanceMeasurementSystem,
    int numberOfHands,
    String holdType,
    String fingerConfiguration,
    double holdDepth,
    int hangsPerSet,
    int numberOfSets,
    int resistance,
    int breakDuration,
    int repDuration,
    int restDuration,
  }) {
    return HangboardExercise(
      exerciseTitle ?? this.exerciseTitle,
      depthMeasurementSystem ?? this.depthMeasurementSystem,
      resistanceMeasurementSystem ?? this.resistanceMeasurementSystem,
      numberOfHands ?? this.numberOfHands,
      holdType ?? this.holdType,
      holdDepth ?? this.holdDepth,
      hangsPerSet ?? this.hangsPerSet,
      numberOfSets ?? this.numberOfSets,
      repDuration ?? this.repDuration,
      restDuration ?? this.restDuration,
      fingerConfiguration: fingerConfiguration ?? this.fingerConfiguration,
      breakDuration: breakDuration ?? this.breakDuration,
      resistance: resistance ?? this.resistance,
    );
  }

  @override
  String toString() {
    return '''HangboardExercise {
    exerciseTitle: $exerciseTitle,
    depthMeasurementSystem: $depthMeasurementSystem, 
    resistanceMeasurementSystem: $resistanceMeasurementSystem, 
    numberOfHands: $numberOfHands, 
    holdType: $holdType, 
    fingerConfiguration: $fingerConfiguration, 
    holdDepth: $holdDepth, 
    hangsPerSet: $hangsPerSet, 
    numberOfSets: $numberOfSets, 
    resistance: $resistance, 
    breakDuration: $breakDuration, 
    repDuration: $repDuration, 
    restDuration: $restDuration 
    }''';
  }

  HangboardExerciseEntity toEntity() {
    return HangboardExerciseEntity(
      exerciseTitle,
      depthMeasurementSystem,
      resistanceMeasurementSystem,
      numberOfHands,
      holdType,
      fingerConfiguration,
      holdDepth,
      hangsPerSet,
      numberOfSets,
      resistance,
      breakDuration,
      repDuration,
      restDuration,
    );
  }

  static HangboardExercise fromEntity(HangboardExerciseEntity entity) {
    return HangboardExercise(
      entity.exerciseTitle,
      entity.depthMeasurementSystem,
      entity.resistanceMeasurementSystem,
      entity.numberOfHands,
      entity.holdType,
      entity.holdDepth,
      entity.hangsPerSet,
      entity.numberOfSets,
      entity.repDuration,
      entity.restDuration,
      fingerConfiguration: entity.fingerConfiguration,
      breakDuration: entity.breakDuration,
      resistance: entity.resistance,
    );
  }

  @override
  List<Object> get props =>
      [
        exerciseTitle,
        depthMeasurementSystem,
        resistanceMeasurementSystem,
        numberOfHands,
        holdType,
        holdDepth,
        hangsPerSet,
        numberOfSets,
        repDuration,
        restDuration,
        fingerConfiguration,
        breakDuration,
      ];
}
