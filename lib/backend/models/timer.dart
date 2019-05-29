import 'package:crux/backend/models/timer_direction.dart';
import 'package:crux/backend/repository/entities/timer_entity.dart';
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
  //TODO: figure out what to do with them / if i need them anymore

//  final bool startTimer;
//  final bool preferencesClearedFlag;

  Timer(this.id,
        this.timerDuration,
        this.timerDirection,);

  /*Timer copyWith(
      {int timerDuration, String id, TimerDirection timerDirection}) {
    return Timer(
      timerDuration: timerDuration ?? this.timerDuration,
      id: id ?? this.id,
      timerDirection: timerDirection ?? this.timerDirection,
    );
  }*/

  @override
  String toString() {
    return 'Timer { id: $id, timerDuration: $timerDuration, timerDirection: $timerDirection,}';
  }

  TimerEntity toEntity() {
    return TimerEntity(id, timerDuration, timerDirection);
  }

  static Timer fromEntity(TimerEntity entity) {
    return Timer(
      entity.id,
      entity.timerDuration,
      entity.timerDirection,
    );
  }
}
