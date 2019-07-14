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
  final double resistance;
  final int breakDuration;
  final int repDuration;
  final int restDuration;

  HangboardExercise(this.exerciseTitle,
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
                    this.restDuration,);


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
                               double resistance,
                               int breakDuration,
                               int repDuration,
                               int restDuration,
                             }) {
    return HangboardExercise(
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

  @override
  String toString() {
    return 'HangboardExercise{ exerciseTitle: $exerciseTitle, '
        'depthMeasurementSystem: $depthMeasurementSystem, '
        'resistanceMeasurementSystem: $resistanceMeasurementSystem, '
        'numberOfHands: $numberOfHands, '
        'holdType: $holdType, '
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

  HangboardExercise fromEntity(HangboardExerciseEntity entity) {
    return HangboardExercise(
      entity.exerciseTitle,
      entity.depthMeasurementSystem,
      entity.resistanceMeasurementSystem,
      entity.numberOfHands,
      entity.holdType,
      entity.fingerConfiguration,
      entity.holdDepth,
      entity.hangsPerSet,
      entity.numberOfSets,
      entity.resistance,
      entity.breakDuration,
      entity.repDuration,
      entity.restDuration,
    );
  }
}
