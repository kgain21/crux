import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardWorkoutState extends Equatable {
  HangboardWorkoutState([List props = const []]) : super(props);
//todo: also need to update workout event names

//todo: also havent done exercise_page_view yet

}

class HangboardWorkoutLoading extends HangboardWorkoutState {
  @override
  String toString() => 'HangboardWorkoutLoading';
}

class HangboardWorkoutLoaded extends HangboardWorkoutState {
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutLoaded(
    this.hangboardWorkout,
  ) : super([
          hangboardWorkout,
        ]);

  @override
  String toString() {
    return 'HangboardWorkoutLoaded: {'
        'hangboardWorkout: ${hangboardWorkout.toString()}'
        '}';
  }
}

class HangboardWorkoutNotLoaded extends HangboardWorkoutState {
  @override
  String toString() => 'HangboardWorkoutNotLoaded';
}
