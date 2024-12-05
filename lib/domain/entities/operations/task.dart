import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus {
  todo,
  inProgress,
  review,
  done,
  blocked,
  cancelled
}

enum Priority {
  low,
  medium,
  high,
  urgent
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String name,
    @Default('') String description,
    required TaskStatus status,
    required String assigneeId,
    required DateTime dueDate,
    required Priority priority,
    @Default([]) List<String> labels,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
