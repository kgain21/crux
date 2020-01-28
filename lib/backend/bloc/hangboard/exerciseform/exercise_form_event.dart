import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExerciseFormEvent extends Equatable {
  ExerciseFormEvent();
}

class ExerciseFormResistanceMeasurementSystemChanged extends ExerciseFormEvent {
  final String resistanceMeasurementSystem;

  ExerciseFormResistanceMeasurementSystemChanged(
      this.resistanceMeasurementSystem);

  @override
  String toString() =>
      'ExerciseFormResistanceMeasurementSystemChanged { resistanceMeasurementSystem: $resistanceMeasurementSystem }';

  @override
  List<Object> get props => [resistanceMeasurementSystem];
}

class ExerciseFormDepthMeasurementSystemChanged extends ExerciseFormEvent {
  final String depthMeasurementSystem;

  ExerciseFormDepthMeasurementSystemChanged(this.depthMeasurementSystem);

  @override
  String toString() =>
      'ExerciseFormDepthMeasurementSystemChanged { depthMeasurementSystem: $depthMeasurementSystem }';

  @override
  List<Object> get props => [depthMeasurementSystem];
}

class ExerciseFormNumberOfHandsChanged extends ExerciseFormEvent {
  final int numberOfHandsSelected;

  ExerciseFormNumberOfHandsChanged(this.numberOfHandsSelected);

  @override
  String toString() =>
      'ExerciseFormNumberOfHandsChanged { numberOfHands: $numberOfHandsSelected }';

  @override
  List<Object> get props => [numberOfHandsSelected];
}

class ExerciseFormHoldChanged extends ExerciseFormEvent {
  final Hold hold;

  ExerciseFormHoldChanged(this.hold);

  @override
  String toString() => 'ExerciseFormHoldChanged { hold: $hold }';

  @override
  List<Object> get props => [hold];
}

class ExerciseFormFingerConfigurationChanged extends ExerciseFormEvent {
  final FingerConfiguration fingerConfiguration;

  ExerciseFormFingerConfigurationChanged(this.fingerConfiguration);

  @override
  String toString() =>
      'ExerciseFormFingerConfigurationChanged { fingerConfiguration: $fingerConfiguration }';

  @override
  List<Object> get props => [fingerConfiguration];
}

class ExerciseFormDepthChanged extends ExerciseFormEvent {
  final String depth;

  ExerciseFormDepthChanged(this.depth);

  @override
  String toString() => 'ExerciseFormDepthChanged { depth: $depth }';

  @override
  List<Object> get props => [depth];
}

class ExerciseFormTimeOffChanged extends ExerciseFormEvent {
  final String timeOff;

  ExerciseFormTimeOffChanged(this.timeOff);

  @override
  String toString() => 'ExerciseFormTimeOffChanged { timeOff: $timeOff }';

  @override
  List<Object> get props => [timeOff];
}

class ExerciseFormTimeOnChanged extends ExerciseFormEvent {
  final String timeOn;

  ExerciseFormTimeOnChanged(this.timeOn);

  @override
  String toString() => 'ExerciseFormTimeOnChanged { timeOn: $timeOn }';

  @override
  List<Object> get props => [timeOn];
}

class ExerciseFormHangsPerSetChanged extends ExerciseFormEvent {
  final String hangsPerSet;

  ExerciseFormHangsPerSetChanged(this.hangsPerSet);

  @override
  String toString() =>
      'ExerciseFormHangsPerSetChanged { hangsPerSet: $hangsPerSet }';

  @override
  List<Object> get props => [hangsPerSet];
}

class ExerciseFormTimeBetweenSetsChanged extends ExerciseFormEvent {
  final String timeBetweenSets;

  ExerciseFormTimeBetweenSetsChanged(this.timeBetweenSets);

  @override
  String toString() =>
      'ExerciseFormTimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';

  @override
  List<Object> get props => [timeBetweenSets];
}

class ExerciseFormNumberOfSetsChanged extends ExerciseFormEvent {
  final String numberOfSets;

  ExerciseFormNumberOfSetsChanged(this.numberOfSets);

  @override
  String toString() =>
      'ExerciseFormNumberOfSetsChanged { numberOfSets: $numberOfSets }';

  @override
  List<Object> get props => [numberOfSets];
}

class ExerciseFormResistanceChanged extends ExerciseFormEvent {
  final String resistance;

  ExerciseFormResistanceChanged(this.resistance);

  @override
  String toString() =>
      'ExerciseFormResistanceChanged { resistance: $resistance }';

  @override
  List<Object> get props => [resistance];
}

class ExerciseFormFlagsReset extends ExerciseFormEvent {
  ExerciseFormFlagsReset();

  @override
  String toString() => 'ExerciseFormFlagsReset';

  @override
  List<Object> get props => [];
}

//todo: simplify this to one save event?
class ExerciseFormSaveInvalid extends ExerciseFormEvent {
  ExerciseFormSaveInvalid();

  @override
  String toString() => 'ExerciseFormSaveInvalid';

  @override
  List<Object> get props => [];
}

class ValidExerciseFormSaved extends ExerciseFormEvent {
  final String resistanceMeasurementSystem;
  final String depthMeasurementSystem;
  final int numberOfHandsSelected;
  final Hold hold;
  final FingerConfiguration fingerConfiguration;
  final String depth;
  final String timeOff;
  final String timeOn;
  final String timeBetweenSets;
  final String hangsPerSet;
  final String numberOfSets;
  final String resistance;

  ValidExerciseFormSaved(
    this.resistanceMeasurementSystem,
    this.depthMeasurementSystem,
    this.numberOfHandsSelected,
    this.hold,
    this.fingerConfiguration,
    this.depth,
    this.timeOff,
    this.timeOn,
    this.timeBetweenSets,
    this.hangsPerSet,
    this.numberOfSets,
    this.resistance,
  );

  @override
  String toString() => 'ValidExerciseFormSaved';

  @override
  List<Object> get props => [
        resistanceMeasurementSystem,
        depthMeasurementSystem,
        numberOfHandsSelected,
        hold,
        fingerConfiguration,
        depth,
        timeOff,
        timeOn,
        timeBetweenSets,
        hangsPerSet,
        numberOfSets,
        resistance,
      ];
}
