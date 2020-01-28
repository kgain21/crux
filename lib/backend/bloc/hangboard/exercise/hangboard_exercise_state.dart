import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseState extends Equatable {
  HangboardExerciseState();
}

class HangboardExerciseLoadInProgress extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExerciseLoadInProgress';

  @override
  List<Object> get props => [];
}

class HangboardExerciseLoadSuccess extends HangboardExerciseState {
  final HangboardExercise hangboardExercise;

  HangboardExerciseLoadSuccess(this.hangboardExercise);

  @override
  String toString() => 'HangboardExerciseLoadSuccess';

  @override
  List<Object> get props => [hangboardExercise];
}

class HangboardExerciseLoadFailure extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExerciseLoadFailure';

  @override
  List<Object> get props => [];
}
