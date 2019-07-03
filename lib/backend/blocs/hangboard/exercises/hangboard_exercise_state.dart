import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardExerciseState extends Equatable {
  HangboardExerciseState([List props = const []]) : super(props);
}

class HangboardExerciseLoading extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExercise Loading';
}

class HangboardExerciseLoaded extends HangboardExerciseState {
  final HangboardExercise hangboardExercise;

  HangboardExerciseLoaded(
      this.hangboardExercise)
      : super([hangboardExercise]);

  @override
  String toString() => 'HangboardExercise Loaded';
}

class HangboardExerciseNotLoaded extends HangboardExerciseState {
  @override
  String toString() => 'HangboardExercise Not Loaded';
}
