import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_failure.freezed.dart';

@freezed
class ProjectFailure with _$ProjectFailure {
  const factory ProjectFailure.emptyName() = _EmptyName;
  const factory ProjectFailure.noClient() = _NoClient;
  const factory ProjectFailure.noTemplate() = _NoTemplate;
  const factory ProjectFailure.noStartDate() = _NoStartDate;
  const factory ProjectFailure.noEndDate() = _NoEndDate;
  const factory ProjectFailure.invalidDates() = _InvalidDates;
  const factory ProjectFailure.insufficientPermissions() = _InsufficientPermissions;
  const factory ProjectFailure.unableToCreate() = _UnableToCreate;
  const factory ProjectFailure.unableToUpdate() = _UnableToUpdate;
  const factory ProjectFailure.unableToDelete() = _UnableToDelete;
  const factory ProjectFailure.unexpected() = _Unexpected;
}
