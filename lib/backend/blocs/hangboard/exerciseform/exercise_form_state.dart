import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ExerciseFormState extends Equatable {
  final bool isFingerConfigurationVisible;
  final bool isTimeBetweenSetsVisible;
  final bool isDepthVisible;

  final bool isTwoHandsSelected;
  final Hold holdSelected;
  final FingerConfiguration fingerConfigurationSelected;

  final List<FingerConfiguration> availableFingerConfigurations;

  final bool autoValidate;

  final double depth;
  final int timeOff;
  final int timeOn;
  final int hangsPerSet;
  final int timeBetweenSets;
  final int numberOfSets;
  final int resistance;

  ExerciseFormState({
                      this.isDepthVisible,
                      this.autoValidate,
    this.isFingerConfigurationVisible,
    this.isTimeBetweenSetsVisible,
    this.isTwoHandsSelected,
    this.holdSelected,
    this.availableFingerConfigurations,
    this.fingerConfigurationSelected,
                      this.depth,
                      this.timeOff,
                      this.timeOn,
                      this.hangsPerSet,
                      this.timeBetweenSets,
                      this.numberOfSets,
                      this.resistance,
  }) : super([
    isDepthVisible,
    autoValidate,
    isFingerConfigurationVisible,
    isTimeBetweenSetsVisible,
    isTwoHandsSelected,
    holdSelected,
    availableFingerConfigurations,
    fingerConfigurationSelected,
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
        isDepthVisible: false,
        autoValidate: false,
        availableFingerConfigurations: FingerConfiguration.values,
        isFingerConfigurationVisible: false,
        isTimeBetweenSetsVisible: true,
        isTwoHandsSelected: true,
        holdSelected: null,
        fingerConfigurationSelected: null,
        depth: null,
        timeOff: null,
        timeOn: null,
        hangsPerSet: null,
        timeBetweenSets: null,
        numberOfSets: null,
        resistance: null);
  }

  ExerciseFormState update({
                             bool isDepthVisible,
                             bool autoValidate,
    List<FingerConfiguration> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
    bool isTwoHandsSelected,
    Hold holdSelected,
    FingerConfiguration fingerConfigurationSelected,
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
      isDepthVisible: isDepthVisible,
      autoValidate: autoValidate,
      availableFingerConfigurations: availableFingerConfigurations,
      isDepthMeasurementSystemValid: isDepthMeasurementSystemValid,
      isResistanceMeasurementSystemValid: isResistanceMeasurementSystemValid,
      isTwoHandsSelected: isTwoHandsSelected,
      holdSelected: holdSelected,
      fingerConfigurationSelected: fingerConfigurationSelected,
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
                               bool isDepthVisible,
                               bool autoValidate,
    List<FingerConfiguration> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
    bool isTwoHandsSelected,
    Hold holdSelected,
    FingerConfiguration fingerConfigurationSelected,
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
      isDepthVisible: isDepthVisible ?? this.isDepthVisible,
      autoValidate: autoValidate ?? this.autoValidate,
      availableFingerConfigurations:
      availableFingerConfigurations ?? this.availableFingerConfigurations,
      isFingerConfigurationVisible:
      isFingerConfigurationVisible ?? this.isFingerConfigurationVisible,
      isTimeBetweenSetsVisible:
      isTimeBetweenSetsVisible ?? this.isTimeBetweenSetsVisible,
      isTwoHandsSelected: isTwoHandsSelected ?? this.isTwoHandsSelected,
      holdSelected: holdSelected ?? this.holdSelected,
      fingerConfigurationSelected:
      fingerConfigurationSelected ?? this.fingerConfigurationSelected,
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
      isNumberOfHandsValid $isTwoHandsSelected,
      isHoldValid $holdSelected,
      isFingerConfigurationValid $fingerConfigurationSelected,
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
