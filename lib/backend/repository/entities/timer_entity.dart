class TimerEntity {
  final bool complete;
  final String id;
  final String note;
  final String task;

  TimerEntity(this.task, this.id, this.note, this.complete);

  @override
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
          id == other.id;

  Map<String, Object> toJson() {
    return {
      "complete": complete,
      "task": task,
      "note": note,
      "id": id,
    };
  }

  @override
  String toString() {
    return 'TimerEntity{complete: $complete, task: $task, note: $note, id: $id}';
  }

  static TimerEntity fromJson(Map<String, Object> json) {
    return TimerEntity(
      json["task"] as String,
      json["id"] as String,
      json["note"] as String,
      json["complete"] as bool,
    );
  }
}
