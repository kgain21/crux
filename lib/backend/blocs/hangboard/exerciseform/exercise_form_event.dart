import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExerciseFormEvent extends Equatable {
  ExerciseFormEvent([List props = const []]) : super(props);
}

class ResistanceMeasurementSystemChanged extends ExerciseFormEvent {
  final String resistanceMeasurementSystem;

  ResistanceMeasurementSystemChanged(
      {@required this.resistanceMeasurementSystem})
      : super([resistanceMeasurementSystem]);

  @override
  String toString() =>
      'ResistanceMeasurementSystemChanged { resistanceMeasurementSystem: $resistanceMeasurementSystem }';
}

class DepthMeasurementSystemChanged extends ExerciseFormEvent {
  final String depthMeasurementSystem;

  DepthMeasurementSystemChanged({@required this.depthMeasurementSystem})
      : super([depthMeasurementSystem]);

  @override
  String toString() =>
      'DepthMeasurementSystemChanged { depthMeasurementSystem: $depthMeasurementSystem }';
}

class NumberOfHandsChanged extends ExerciseFormEvent {
  final int numberOfHandsSelected;

  NumberOfHandsChanged({@required this.numberOfHandsSelected})
      : super([numberOfHandsSelected]);

  @override
  String toString() =>
      'NumberOfHandsChanged { numberOfHands: $numberOfHandsSelected }';
}

class HoldChanged extends ExerciseFormEvent {
  final Hold hold;

  HoldChanged({@required this.hold}) : super([hold]);

  @override
  String toString() => 'HoldChanged { hold: $hold }';
}

class FingerConfigurationChanged extends ExerciseFormEvent {
  final FingerConfiguration fingerConfiguration;

  FingerConfigurationChanged({@required this.fingerConfiguration})
      : super([fingerConfiguration]);

  @override
  String toString() =>
      'FingerConfigurationChanged { fingerConfiguration: $fingerConfiguration }';
}

class DepthChanged extends ExerciseFormEvent {
  final String depth;

  DepthChanged({@required this.depth}) : super([depth]);

  @override
  String toString() => 'DepthChanged { depth: $depth }';
}

class TimeOffChanged extends ExerciseFormEvent {
  final String timeOff;

  TimeOffChanged({@required this.timeOff}) : super([timeOff]);

  @override
  String toString() => 'TimeOffChanged { timeOff: $timeOff }';
}

class TimeOnChanged extends ExerciseFormEvent {
  final String timeOn;

  TimeOnChanged({@required this.timeOn}) : super([timeOn]);

  @override
  String toString() => 'TimeOnChanged { timeOn: $timeOn }';
}

class HangsPerSetChanged extends ExerciseFormEvent {
  final String hangsPerSet;

  HangsPerSetChanged({@required this.hangsPerSet}) : super([hangsPerSet]);

  @override
  String toString() => 'HangsPerSetChanged { hangsPerSet: $hangsPerSet }';
}

class TimeBetweenSetsChanged extends ExerciseFormEvent {
  final String timeBetweenSets;

  TimeBetweenSetsChanged({@required this.timeBetweenSets})
      : super([timeBetweenSets]);

  @override
  String toString() =>
      'TimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';
}

class NumberOfSetsChanged extends ExerciseFormEvent {
  final String numberOfSets;

  NumberOfSetsChanged({@required this.numberOfSets}) : super([numberOfSets]);

  @override
  String toString() => 'NumberOfSetsChanged { numberOfSets: $numberOfSets }';
}

class ResistanceChanged extends ExerciseFormEvent {
  final String resistance;

  ResistanceChanged({@required this.resistance}) : super([resistance]);

  @override
  String toString() => 'ResistanceChanged { resistance: $resistance }';
}

class InvalidExerciseFormSaved extends ExerciseFormEvent {
  InvalidExerciseFormSaved();

  @override
  String toString() => 'InvalidExerciseFormSaved';
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

  ValidExerciseFormSaved(this.resistanceMeasurementSystem,
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
                         this.resistance,) : super([
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
  ]);

  @override
  String toString() => 'ValidExerciseFormSaved';
}
