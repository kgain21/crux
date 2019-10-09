import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ExerciseFormEvent extends Equatable {
  ExerciseFormEvent([List props = const []]) : super(props);
}

class NumberOfHandsChanged extends ExerciseFormEvent {
  final bool isTwoHandsSelected;

  NumberOfHandsChanged({@required this.isTwoHandsSelected})
      : super([isTwoHandsSelected]);

  @override
  String toString() =>
      'NumberOfHandsChanged { numberOfHands: $isTwoHandsSelected }';
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
  final int depth;

  DepthChanged({@required this.depth}) : super([depth]);

  @override
  String toString() => 'DepthChanged { depth: $depth }';
}

class TimeOffChanged extends ExerciseFormEvent {
  final int timeOff;

  TimeOffChanged({@required this.timeOff}) : super([timeOff]);

  @override
  String toString() => 'TimeOffChanged { timeOff: $timeOff }';
}

class TimeOnChanged extends ExerciseFormEvent {
  final int timeOn;

  TimeOnChanged({@required this.timeOn}) : super([timeOn]);

  @override
  String toString() => 'TimeOnChanged { timeOn: $timeOn }';
}

class HangsPerSetChanged extends ExerciseFormEvent {
  final int hangsPerSet;

  HangsPerSetChanged({@required this.hangsPerSet}) : super([hangsPerSet]);

  @override
  String toString() => 'HangsPerSetChanged { hangsPerSet: $hangsPerSet }';
}

class TimeBetweenSetsChanged extends ExerciseFormEvent {
  final int timeBetweenSets;

  TimeBetweenSetsChanged({@required this.timeBetweenSets})
      : super([timeBetweenSets]);

  @override
  String toString() =>
      'TimeBetweenSetsChanged { timeBetweenSets: $timeBetweenSets }';
}

class NumberOfSetsChanged extends ExerciseFormEvent {
  final int numberOfSets;

  NumberOfSetsChanged({@required this.numberOfSets}) : super([numberOfSets]);

  @override
  String toString() => 'NumberOfSetsChanged { numberOfSets: $numberOfSets }';
}

class ResistanceChanged extends ExerciseFormEvent {
  final int resistance;

  ResistanceChanged({@required this.resistance}) : super([resistance]);

  @override
  String toString() => 'ResistanceChanged { resistance: $resistance }';
}

class ExerciseFormSaved extends ExerciseFormEvent {

  ExerciseFormSaved();

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}
