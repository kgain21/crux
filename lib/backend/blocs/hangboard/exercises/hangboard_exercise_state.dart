import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseState extends Equatable {
  HangboardExerciseState([List props = const []]) : super(props);
}

class HangboardExerciseLoading extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExercise Loading';
}

class HangboardExerciseLoaded extends HangboardExerciseState {
  /*final String exerciseTitle;
  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHands;
  final String holdType; // Formerly hold
  final String fingerConfiguration;
  final double holdDepth; // formerly depth
  final int hangsPerSet;
  final int numberOfSets;
  final double resistance;
  final int timeBetweenSets;
  final int repDuration; // Formerly timeOn
  final int restDuration; // Formerly timeOff*/
  final HangboardExercise hangboardExercise;

  HangboardExerciseLoaded(
      /*this.exerciseTitle,
      this.depthMeasurementSystem,
      this.resistanceMeasurementSystem,
      this.numberOfHands,
      this.holdType,
      this.fingerConfiguration,
      this.holdDepth,
      this.hangsPerSet,
      this.numberOfSets,
      this.resistance,
      this.timeBetweenSets,
      this.repDuration,
      this.restDuration)
      : super([
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
          timeBetweenSets,
          repDuration,
          restDuration
        ]);*/
      this.hangboardExercise)
      : super([hangboardExercise]);

  @override
  String toString() => 'HangboardExercise Loaded';
}

class HangboardExerciseNotLoaded extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExercise Not Loaded';
}
