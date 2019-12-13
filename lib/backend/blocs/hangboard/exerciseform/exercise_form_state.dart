import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ExerciseFormState extends Equatable {
  final bool isFingerConfigurationVisible;
  final List<FingerConfiguration> availableFingerConfigurations;
  final bool isTimeBetweenSetsVisible;
  final bool isDepthVisible;

  final FingerConfiguration fingerConfiguration;

  final bool autoValidate;

  final String depthMeasurementSystem;
  final String resistanceMeasurementSystem;
  final int numberOfHandsSelected;
  final Hold hold;
  final bool isDepthValid;
  final bool isTimeOffValid;
  final bool isTimeOnValid;
  final bool isHangsPerSetValid;
  final bool isTimeBetweenSetsValid;
  final bool isNumberOfSetsValid;
  final bool isResistanceValid;

  final bool isSuccess;
  final bool isFailure;

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
                      this.isDepthValid,
                      this.isTimeOffValid,
                      this.isTimeOnValid,
                      this.isHangsPerSetValid,
                      this.isTimeBetweenSetsValid,
                      this.isNumberOfSetsValid,
                      this.isResistanceValid,
                      this.isSuccess,
                      this.isFailure,
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
    isDepthValid,
    isTimeOffValid,
    isTimeOnValid,
    isHangsPerSetValid,
    isTimeBetweenSetsValid,
    isNumberOfSetsValid,
    isResistanceValid,
    isSuccess,
    isFailure,
        ]);

  factory ExerciseFormState.initial() {
    return ExerciseFormState(
      depthMeasurementSystem: 'mm',
      resistanceMeasurementSystem: 'kg',
      isDepthVisible: false,
      autoValidate: false,
      availableFingerConfigurations: FingerConfiguration.values,
      isFingerConfigurationVisible: false,
      isTimeBetweenSetsVisible: true,
      numberOfHandsSelected: 2,
      hold: null,
      fingerConfiguration: null,
      isDepthValid: true,
      isTimeOffValid: true,
      isTimeOnValid: true,
      isHangsPerSetValid: true,
      isTimeBetweenSetsValid: true,
      isNumberOfSetsValid: true,
      isResistanceValid: true,
      isSuccess: false,
      isFailure: false,
    );
  }

  /*factory ExerciseFormState.success() {
    return ExerciseFormState(
//      depthMeasurementSystem: this.depthMeasurementSystem,
//      resistanceMeasurementSystem: 'kg',
      isDepthVisible: false,
      autoValidate: false,
      availableFingerConfigurations: FingerConfigurations.values,
      isFingerConfigurationVisible: false,
      isTimeBetweenSetsVisible: true,
//      numberOfHandsSelected: 2,
//      hold: null,
//      fingerConfiguration: null,
      isDepthValid: true,
      isTimeOffValid: true,
      isTimeOnValid: true,
      isHangsPerSetValid: true,
      isTimeBetweenSetsValid: true,
      isNumberOfSetsValid: true,
      isResistanceValid: true,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory ExerciseFormState.failure() {
    return ExerciseFormState(
//      depthMeasurementSystem: 'mm',
//      resistanceMeasurementSystem: 'kg',
      isDepthVisible: false,
      autoValidate: false,
      availableFingerConfigurations: FingerConfigurations.values,
      isFingerConfigurationVisible: false,
      isTimeBetweenSetsVisible: true,
//      numberOfHandsSelected: 2,
//      hold: null,
//      fingerConfiguration: null,
      isDepthValid: null,
      isTimeOffValid: null,
      isTimeOnValid: null,
      isHangsPerSetValid: null,
      isTimeBetweenSetsValid: null,
      isNumberOfSetsValid: null,
      isResistanceValid: null,
      isSuccess: false,
      isFailure: true,
    );
  }*/

  ExerciseFormState update({
                             String depthMeasurementSystem,
                             String resistanceMeasurementSystem,
                             bool isDepthVisible,
                             bool autoValidate,
                             List<
                                 FingerConfiguration> availableFingerConfigurations,
                             int numberOfHandsSelected,
                             Hold hold,
                             FingerConfiguration fingerConfiguration,
    bool isFingerConfigurationVisible,
                             bool isDepthValid,
                             bool isTimeOffValid,
                             bool isTimeOnValid,
                             bool isHangsPerSetValid,
                             bool isTimeBetweenSetsValid,
                             bool isNumberOfSetsValid,
                             bool isResistanceValid,
                             bool isSuccess,
                             bool isFailure,
  }) {
    return copyWith(
      depthMeasurementSystem: depthMeasurementSystem,
      resistanceMeasurementSystem: resistanceMeasurementSystem,
      isDepthVisible: isDepthVisible,
      autoValidate: autoValidate,
      availableFingerConfigurations: availableFingerConfigurations,
      numberOfHandsSelected: numberOfHandsSelected,
      hold: hold,
      fingerConfiguration: fingerConfiguration,
      isFingerConfigurationVisible: isFingerConfigurationVisible,
      isDepthValid: isDepthValid,
      isTimeOffValid: isTimeOffValid,
      isTimeOnValid: isTimeOnValid,
      isHangsPerSetValid: isHangsPerSetValid,
      isTimeBetweenSetsValid: isTimeBetweenSetsValid,
      isNumberOfSetsValid: isNumberOfSetsValid,
      isResistanceValid: isResistanceValid,
      isSuccess: isSuccess,
      isFailure: isFailure,
    );
  }

  ExerciseFormState copyWith({
                               String depthMeasurementSystem,
                               String resistanceMeasurementSystem,
                               bool isDepthVisible,
                               bool autoValidate,
                               List<
                                   FingerConfiguration> availableFingerConfigurations,
                               int numberOfHandsSelected,
                               Hold hold,
                               FingerConfiguration fingerConfiguration,
    bool isFingerConfigurationVisible,
                               bool isDepthValid,
                               bool isTimeOffValid,
                               bool isTimeOnValid,
                               bool isHangsPerSetValid,
                               bool isTimeBetweenSetsValid,
                               bool isNumberOfSetsValid,
                               bool isResistanceValid,
                               bool isSuccess,
                               bool isFailure,
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
      numberOfHandsSelected:
      numberOfHandsSelected ?? this.numberOfHandsSelected,
      hold: hold ?? this.hold,
      fingerConfiguration: fingerConfiguration ?? this.fingerConfiguration,
      isDepthValid: isDepthValid ?? this.isDepthValid,
      isTimeOffValid: isTimeOffValid ?? this.isTimeOffValid,
      isTimeOnValid: isTimeOnValid ?? this.isTimeOnValid,
      isHangsPerSetValid: isHangsPerSetValid ?? this.isHangsPerSetValid,
      isTimeBetweenSetsValid:
      isTimeBetweenSetsValid ?? this.isTimeBetweenSetsValid,
      isNumberOfSetsValid: isNumberOfSetsValid ?? this.isNumberOfSetsValid,
      isResistanceValid: isResistanceValid ?? this.isResistanceValid,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
    );
  }

  //todo: fix this when state is figured out
  @override
  String toString() {
    return '''NewExerciseFormState {
    autoValidate: $autoValidate,
      isDepthValid $isDepthValid,
      isTimeOffValid $isTimeOffValid,
      isTimeOnValid $isTimeOnValid,
      isHangsPerSetValid $isHangsPerSetValid,
      isTimeBetweenSetsValid $isTimeBetweenSetsValid,
      isNumberOfSetsValid $isNumberOfSetsValid,
      isResistanceValid $isResistanceValid,
    }''';
  }
}
