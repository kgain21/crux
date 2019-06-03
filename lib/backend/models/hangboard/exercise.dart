class Exercise {
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

  Exercise(
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
      this.restDuration);

  /*TODO: going to hold off on these for now but may need in future
  @override
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

  Map<String, Object> toJson() {
    return {
      "depthMeasurementSystem": depthMeasurementSystem,
      "resistanceMeasurementSystem": resistanceMeasurementSystem,
      "numberOfHands": numberOfHands,
      "holdType": holdType,
      "fingerConfiguration": fingerConfiguration,
      "holdDepth": holdDepth,
      "hangsPerSet": hangsPerSet,
      "numberOfSets": numberOfSets,
      "resistance": resistance,
      "timeBetweenSets": timeBetweenSets,
      "repDuration": repDuration,
      "restDuration": restDuration,
    };
  }

  @override
  String toString() {
    return 'Exercise{depthMeasurementSystem: $depthMeasurementSystem, '
        'resistanceMeasurementSystem: $resistanceMeasurementSystem, '
        'numberOfHands: $numberOfHands, '
        'holdType: $holdType,'
        'fingerConfiguration: $fingerConfiguration,'
        'holdDepth: $holdDepth,'
        'hangsPerSet: $hangsPerSet,'
        'numberOfSets: $numberOfSets,'
        'resistance: $resistance,'
        'timeBetweenSets: $timeBetweenSets,'
        'repDuration: $repDuration,'
        'restDuration: $restDuration,'
        '}';
  }

  static Exercise fromJson(Map<String, Object> json) {
    return Exercise(
      json["depthMeasurementSystem"] as String,
      json["resistanceMeasurementSystem"] as String,
      json["numberOfHands"] as int,
      json["holdType"] as String,
      json["fingerConfiguration"] as String,
      json["holdDepth"] as double,
      json["hangsPerSet"] as int,
      json["numberOfSets"] as int,
      json["resistance"] as double,
      json["timeBetweenSets"] as int,
      json["repDuration"] as int,
      json["restDuration"] as int,
    );
  }
}
