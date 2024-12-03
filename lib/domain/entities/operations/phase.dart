import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:neetiflow/domain/entities/operations/task.dart';

part 'phase.freezed.dart';
part 'phase.g.dart';

@freezed
class Phase with _$Phase {
  const factory Phase({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required List<String> taskIds,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int order,
    required Duration estimatedDuration,
    @Default([]) List<Task> defaultTasks,
  }) = _Phase;

  factory Phase.fromJson(Map<String, dynamic> json) => _$PhaseFromJson(json);
}
