class ExerciseEntity {
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
  final int restDuration; // Formerly timeOff

  ExerciseEntity(
      {this.depthMeasurementSystem,
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
      this.restDuration});
}
