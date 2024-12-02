import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_activity.freezed.dart';
part 'project_activity.g.dart';

enum ActivityType {
  created,
  updated,
  memberAdded,
  memberRemoved,
  fileUploaded,
  fileDeleted,
  taskCreated,
  taskCompleted,
  milestoneReached,
  statusChanged,
}

@freezed
class ProjectActivity with _$ProjectActivity {
  const factory ProjectActivity({
    required String id,
    required String projectId,
    required String employeeId,
    required String employeeName,
    required String action,
    required Map<String, dynamic> details,
    required DateTime timestamp,
  }) = _ProjectActivity;

  factory ProjectActivity.fromJson(Map<String, dynamic> json) =>
      _$ProjectActivityFromJson(json);
}
