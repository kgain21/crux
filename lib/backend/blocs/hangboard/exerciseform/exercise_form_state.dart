import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ExerciseFormState extends Equatable {
  final bool isFingerConfigurationVisible;
  final List<FingerConfigurations> availableFingerConfigurations;
  final bool isTimeBetweenSetsVisible;
  final bool isDepthVisible;

  final FingerConfigurations fingerConfiguration;

  final bool autoValidate;

  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHandsSelected;
  final Holds hold;
  final double depth;
  final int timeOff;
  final int timeOn;
  final int hangsPerSet;
  final int timeBetweenSets;
  final int numberOfSets;
  final int resistance;

  ExerciseFormState({
                      this.depthMeasurementSystem,
                      this.resistanceMeasurementSystem,
                      this.isDepthVisible,
                      this.autoValidate,
    this.isFingerConfigurationVisible,
    this.isTimeBetweenSetsVisible,
                      this.numberOfHandsSelected,
                      this.hold,
    this.availableFingerConfigurations,
                      this.fingerConfiguration,
                      this.depth,
                      this.timeOff,
                      this.timeOn,
                      this.hangsPerSet,
                      this.timeBetweenSets,
                      this.numberOfSets,
                      this.resistance,
  }) : super([
    depthMeasurementSystem,
    resistanceMeasurementSystem,
    isDepthVisible,
    autoValidate,
    isFingerConfigurationVisible,
    isTimeBetweenSetsVisible,
    numberOfHandsSelected,
    hold,
    availableFingerConfigurations,
    fingerConfiguration,
    depth,
    timeOff,
    timeOn,
    hangsPerSet,
    timeBetweenSets,
    numberOfSets,
    resistance,
        ]);

  factory ExerciseFormState.initial() {
    return ExerciseFormState(
        depthMeasurementSystem: 'mm',
        resistanceMeasurementSystem: 'kg',
        isDepthVisible: false,
        autoValidate: false,
        availableFingerConfigurations: FingerConfigurations.values,
        isFingerConfigurationVisible: false,
        isTimeBetweenSetsVisible: true,
        numberOfHandsSelected: 2,
        hold: null,
        fingerConfiguration: null,
        depth: null,
        timeOff: null,
        timeOn: null,
        hangsPerSet: null,
        timeBetweenSets: null,
        numberOfSets: null,
        resistance: null);
  }

  ExerciseFormState update({
                             String depthMeasurementSystem,
                             String resistanceMeasurementSystem,
                             bool isDepthVisible,
                             bool autoValidate,
                             List<
                                 FingerConfigurations> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
                             int numberOfHandsSelected,
                             Holds hold,
                             FingerConfigurations fingerConfiguration,
    bool isFingerConfigurationVisible,
                             double depth,
                             int timeOff,
                             int timeOn,
                             int hangsPerSet,
                             int timeBetweenSets,
                             int numberOfSets,
                             int resistance,
  }) {
    return copyWith(
      depthMeasurementSystem: depthMeasurementSystem,
      resistanceMeasurementSystem: resistanceMeasurementSystem,
      isDepthVisible: isDepthVisible,
      autoValidate: autoValidate,
      availableFingerConfigurations: availableFingerConfigurations,
      isDepthMeasurementSystemValid: isDepthMeasurementSystemValid,
      isResistanceMeasurementSystemValid: isResistanceMeasurementSystemValid,
      numberOfHandsSelected: numberOfHandsSelected,
      hold: hold,
      fingerConfiguration: fingerConfiguration,
      isFingerConfigurationVisible: isFingerConfigurationVisible,
      depth: depth,
      timeOff: timeOff,
      timeOn: timeOn,
      hangsPerSet: hangsPerSet,
      timeBetweenSets: timeBetweenSets,
      numberOfSets: numberOfSets,
      resistance: resistance,
    );
  }

  bool get isFormValid =>
      isFingerConfigurationVisible &&
      isTimeBetweenSetsVisible &&
//      isTwoHandsSelected &&
//      holdSelected &&
//      fingerConfigurationSelected &&
          null != depth &&
          null != timeOff &&
          null != timeOn &&
          null != hangsPerSet &&
          null != timeBetweenSets &&
          null != numberOfSets &&
          null != resistance;

  ExerciseFormState copyWith({
                               String depthMeasurementSystem,
                               String resistanceMeasurementSystem,
                               bool isDepthVisible,
                               bool autoValidate,
                               List<
                                   FingerConfigurations> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
                               int numberOfHandsSelected,
                               Holds hold,
                               FingerConfigurations fingerConfiguration,
    bool isFingerConfigurationVisible,
                               double depth,
                               int timeOff,
                               int timeOn,
                               int hangsPerSet,
                               int timeBetweenSets,
                               int numberOfSets,
                               int resistance,
  }) {
    return ExerciseFormState(
      depthMeasurementSystem:
      depthMeasurementSystem ?? this.depthMeasurementSystem,
      resistanceMeasurementSystem:
      resistanceMeasurementSystem ?? this.resistanceMeasurementSystem,
      isDepthVisible: isDepthVisible ?? this.isDepthVisible,
      autoValidate: autoValidate ?? this.autoValidate,
      availableFingerConfigurations:
      availableFingerConfigurations ?? this.availableFingerConfigurations,
      isFingerConfigurationVisible:
      isFingerConfigurationVisible ?? this.isFingerConfigurationVisible,
      isTimeBetweenSetsVisible:
      isTimeBetweenSetsVisible ?? this.isTimeBetweenSetsVisible,
      numberOfHandsSelected: numberOfHandsSelected ??
          this.numberOfHandsSelected,
      hold: hold ?? this.hold,
      fingerConfiguration: fingerConfiguration ?? this.fingerConfiguration,
      depth: depth ?? this.depth,
      timeOff: timeOff ?? this.timeOff,
      timeOn: timeOn ?? this.timeOn,
      hangsPerSet: hangsPerSet ?? this.hangsPerSet,
      timeBetweenSets: timeBetweenSets ?? this.timeBetweenSets,
      numberOfSets: numberOfSets ?? this.numberOfSets,
      resistance: resistance ?? this.resistance,
    );
  }

  //todo: fix this when state is figured out
  @override
  String toString() {
    return '''NewExerciseFormState {
    autoValidate: $autoValidate,
      isDepthMeasurementSystemValid: $isFingerConfigurationVisible, 
      isResistanceMeasurementSystemValid $isTimeBetweenSetsVisible,
      isNumberOfHandsValid $numberOfHandsSelected,
      isHoldValid $hold,
      isFingerConfigurationValid $fingerConfiguration,
      isDepthValid $depth,
      isTimeOffValid $timeOff,
      isTimeOnValid $timeOn,
      isHangsPerSetValid $hangsPerSet,
      isTimeBetweenSetsValid $timeBetweenSets,
      isNumberOfSetsValid $numberOfSets,
      isResistanceValid $resistance,
    }''';
  }
}
