import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardParentEvent extends Equatable {
  HangboardParentEvent([List props = const []]) : super(props);
}

class LoadHangboardParent extends HangboardParentEvent {
  @override
  String toString() => 'LoadHangboardParent';
}

class AddHangboardParent extends HangboardParentEvent {
  final HangboardParent hangboardParent;

  AddHangboardParent(this.hangboardParent) : super([hangboardParent]);

  @override
  String toString() =>
      'AddHangboardParent { hangboardParent: $hangboardParent }';
}

class AddWorkoutToHangboardParent extends HangboardParentEvent {
  final HangboardParent hangboardParent;
  final HangboardWorkout hangboardWorkout;

  AddWorkoutToHangboardParent(this.hangboardParent, this.hangboardWorkout)
      : super([hangboardParent, hangboardWorkout]);

  @override
  String toString() =>
      'AddWorkoutToHangboardParent { hangboardParent: $hangboardParent,'
          ' hangboardWorkout: $hangboardWorkout }';
}

class DeleteParent extends HangboardParentEvent {
  final HangboardParent hangboardParent;

  DeleteParent(this.hangboardParent) : super([hangboardParent]);

  @override
  String toString() => 'DeleteParent { hangboardParent: $hangboardParent }';
}

class HangboardParentUpdated extends HangboardParentEvent {
  final HangboardParent hangboardParent;

  HangboardParentUpdated(this.hangboardParent) : super([hangboardParent]);

  @override
  String toString() =>
      'HangboardParentUpdated { hangboardParent: $hangboardParent }';
}


class DeleteWorkoutFromHangboardParent extends HangboardParentEvent {
  final HangboardWorkout hangboardWorkout;

  DeleteWorkoutFromHangboardParent(this.hangboardWorkout)
      : super([hangboardWorkout]);

  @override
  String toString() {
    return 'DeleteWorkoutFromHangboardParent: {'
        'hangboardWorkout: ${hangboardWorkout.toString()}'
        '}';
  }
}
