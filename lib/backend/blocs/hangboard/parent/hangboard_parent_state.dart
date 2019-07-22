import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HangboardParentState extends Equatable {
  HangboardParentState([List props = const []]) : super(props);
//todo: also need to update workout event names

//todo: also havent done exercise_page_view yet

}

class HangboardParentLoading extends HangboardParentState {
  @override
  String toString() => 'HangboardParentLoading';
}

class HangboardParentLoaded extends HangboardParentState {
  final HangboardParent hangboardParent;

  HangboardParentLoaded(
    this.hangboardParent,
  ) : super([
          hangboardParent,
        ]);

  @override
  String toString() {
    return 'HangboardParentLoaded: {'
        'hangboardParent: ${hangboardParent.toString()}'
        '}';
  }
}

class HangboardParentNotLoaded extends HangboardParentState {
  @override
  String toString() => 'HangboardParentNotLoaded';
}
