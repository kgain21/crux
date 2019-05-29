import 'package:crux/backend/models/timer_direction.dart';

class TimerEntity {
  final String id;
  final int timerDuration;
  final TimerDirection timerDirection;

  TimerEntity(this.id,
              this.timerDuration,
              this.timerDirection,);

  /*@override
  int get hashCode =>
      complete.hashCode ^ task.hashCode ^ note.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerEntity &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          task == other.task &&
          note == other.note &&
          id == other.id;*/

  Map<String, Object> toJson() {
    return {
      "timerDuration": timerDuration,
      "id": id,
      "timerDirection": timerDirection,
    };
  }

  @override
  String toString() {
    return 'TimerEntity { id: $id, timerDuration: $timerDuration, timerDirection: $timerDirection,}';
  }

  static TimerEntity fromJson(Map<String, Object> json) {
    return TimerEntity(
      json["id"] as String,
      json["timerDuration"] as int,
      json["timerDirection"] as TimerDirection,
    );
  }
}
