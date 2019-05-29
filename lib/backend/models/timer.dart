import 'package:crux/model/timer_direction.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Timer extends Equatable {
  final int timerDuration;
  final String id;
  final TimerDirection timerDirection;

//  final bool changeDirection;

  //TODO: Don't think I want to import these - look like UI packages
  // final VoidCallback notifyParentReverseComplete;
  //final VoidCallback notifyParentForwardComplete;
  //TODO: Don't think I want to import these - look like UI packages

//  final bool startTimer;
//  final bool preferencesClearedFlag;

  Timer(this.timerDuration,
      {this.complete = false, String note = '', String id})
      : this.note = note ?? '',
        this.id = id ?? Uuid().generateV4(),
        super([complete, id, note, task]);

  Timer copyWith({bool complete, String id, String note, String task}) {
    return Timer(
      task ?? this.task,
      complete: complete ?? this.complete,
      id: id ?? this.id,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Todo { complete: $complete, task: $task, note: $note, id: $id }';
  }

  TimerEntity toEntity() {
    return TimerEntity(task, id, note, complete);
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(
      entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id ?? Uuid().generateV4(),
    );
  }
}
