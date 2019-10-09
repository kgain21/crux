import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ExerciseFormState extends Equatable {
  final bool isFingerConfigurationVisible;
  final bool isTimeBetweenSetsVisible;

  final bool isTwoHandsSelected;
  final Hold holdSelected;
  final FingerConfiguration fingerConfigurationSelected;

  final List<FingerConfiguration> availableFingerConfigurations;

  /// \/ These need to be validated, ^ these don't (turn them into some other state field)

  final bool isDepthValid;
  final bool isTimeOffValid;
  final bool isTimeOnValid;
  final bool isHangsPerSetValid;
  final bool isTimeBetweenSetsValid;
  final bool isNumberOfSetsValid;
  final bool isResistanceValid;

  ExerciseFormState({
    this.isFingerConfigurationVisible,
    this.isTimeBetweenSetsVisible,
    this.isTwoHandsSelected,
    this.holdSelected,
    this.availableFingerConfigurations,
    this.fingerConfigurationSelected,
    this.isDepthValid,
    this.isTimeOffValid,
    this.isTimeOnValid,
    this.isHangsPerSetValid,
    this.isTimeBetweenSetsValid,
    this.isNumberOfSetsValid,
    this.isResistanceValid,
  }) : super([
          isFingerConfigurationVisible,
          isTimeBetweenSetsVisible,
          isTwoHandsSelected,
          holdSelected,
          availableFingerConfigurations,
          fingerConfigurationSelected,
          isDepthValid,
          isTimeOffValid,
          isTimeOnValid,
          isHangsPerSetValid,
          isTimeBetweenSetsValid,
          isNumberOfSetsValid,
          isResistanceValid,
        ]);

  factory ExerciseFormState.initial() {
    return ExerciseFormState(
        availableFingerConfigurations: FingerConfiguration.values,
        isFingerConfigurationVisible: false,
        isTimeBetweenSetsVisible: true,
        isTwoHandsSelected: true,
        holdSelected: null,
        fingerConfigurationSelected: null,
        isDepthValid: true,
        isTimeOffValid: true,
        isTimeOnValid: true,
        isHangsPerSetValid: true,
        isTimeBetweenSetsValid: true,
        isNumberOfSetsValid: true,
        isResistanceValid: true);
  }

  ExerciseFormState update({
    List<FingerConfiguration> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
    bool isTwoHandsSelected,
    Hold holdSelected,
    FingerConfiguration fingerConfigurationSelected,
    bool isFingerConfigurationVisible,
    bool isDepthValid,
    bool isTimeOffValid,
    bool isTimeOnValid,
    bool isHangsPerSetValid,
    bool isTimeBetweenSetsValid,
    bool isNumberOfSetsValid,
    bool isResistanceValid,
  }) {
    return copyWith(
      availableFingerConfigurations: availableFingerConfigurations,
      isDepthMeasurementSystemValid: isDepthMeasurementSystemValid,
      isResistanceMeasurementSystemValid: isResistanceMeasurementSystemValid,
      isTwoHandsSelected: isTwoHandsSelected,
      holdSelected: holdSelected,
      fingerConfigurationSelected: fingerConfigurationSelected,
      isFingerConfigurationVisible: isFingerConfigurationVisible,
      isDepthValid: isDepthValid,
      isTimeOffValid: isTimeOffValid,
      isTimeOnValid: isTimeOnValid,
      isHangsPerSetValid: isHangsPerSetValid,
      isTimeBetweenSetsValid: isTimeBetweenSetsValid,
      isNumberOfSetsValid: isNumberOfSetsValid,
      isResistanceValid: isResistanceValid,
    );
  }

  bool get isFormValid =>
      isFingerConfigurationVisible &&
      isTimeBetweenSetsVisible &&
//      isTwoHandsSelected &&
//      holdSelected &&
//      fingerConfigurationSelected &&
      isDepthValid &&
      isTimeOffValid &&
      isTimeOnValid &&
      isHangsPerSetValid &&
      isTimeBetweenSetsValid &&
      isNumberOfSetsValid &&
      isResistanceValid;

  ExerciseFormState copyWith({
    List<FingerConfiguration> availableFingerConfigurations,
    bool isDepthMeasurementSystemValid,
    bool isResistanceMeasurementSystemValid,
    bool isTwoHandsSelected,
    Hold holdSelected,
    FingerConfiguration fingerConfigurationSelected,
    bool isFingerConfigurationVisible,
    bool isDepthValid,
    bool isTimeOffValid,
    bool isTimeOnValid,
    bool isHangsPerSetValid,
    bool isTimeBetweenSetsValid,
    bool isNumberOfSetsValid,
    bool isResistanceValid,
  }) {
    return ExerciseFormState(
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
      isDepthValid: isDepthValid ?? this.isDepthValid,
      isTimeOffValid: isTimeOffValid ?? this.isTimeOffValid,
      isTimeOnValid: isTimeOnValid ?? this.isTimeOnValid,
      isHangsPerSetValid: isHangsPerSetValid ?? this.isHangsPerSetValid,
      isTimeBetweenSetsValid:
          isTimeBetweenSetsValid ?? this.isTimeBetweenSetsValid,
      isNumberOfSetsValid: isNumberOfSetsValid ?? this.isNumberOfSetsValid,
      isResistanceValid: isResistanceValid ?? this.isResistanceValid,
    );
  }

  //todo: fix this when state is figured out
  @override
  String toString() {
    return '''NewExerciseFormState {
      isDepthMeasurementSystemValid: $isFingerConfigurationVisible, 
      isResistanceMeasurementSystemValid $isTimeBetweenSetsVisible,
      isNumberOfHandsValid $isTwoHandsSelected,
      isHoldValid $holdSelected,
      isFingerConfigurationValid $fingerConfigurationSelected,
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
