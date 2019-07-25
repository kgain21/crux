import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
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

class UpdateParent extends HangboardParentEvent {
  final HangboardParent hangboardParent;

  UpdateParent(this.hangboardParent) : super([hangboardParent]);

  @override
  String toString() => 'UpdateParent { hangboardParent: $hangboardParent }';
}

class DeleteParent extends HangboardParentEvent {
  final HangboardParent hangboardParent;

  DeleteParent(this.hangboardParent) : super([hangboardParent]);

  @override
  String toString() => 'DeleteParent { hangboardParent: $hangboardParent }';
}
