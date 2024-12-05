// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjectMemberImpl _$$ProjectMemberImplFromJson(Map<String, dynamic> json) =>
    _$ProjectMemberImpl(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      role: json['role'] as String,
      access: $enumDecode(_$ProjectAccessEnumMap, json['access']),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      department: json['department'] as String?,
    );

Map<String, dynamic> _$$ProjectMemberImplToJson(_$ProjectMemberImpl instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'role': instance.role,
      'access': _$ProjectAccessEnumMap[instance.access]!,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'department': instance.department,
    };

const _$ProjectAccessEnumMap = {
  ProjectAccess.view: 'view',
  ProjectAccess.edit: 'edit',
  ProjectAccess.admin: 'admin',
};

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      clientId: json['clientId'] as String,
      client: Client.fromJson(json['client'] as Map<String, dynamic>),
      type: $enumDecode(_$ProjectTypeEnumMap, json['type']),
      status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
      phases: (json['phases'] as List<dynamic>)
          .map((e) => Phase.fromJson(e as Map<String, dynamic>))
          .toList(),
      milestones: (json['milestones'] as List<dynamic>)
          .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>)
          .map((e) => ProjectMember.fromJson(e as Map<String, dynamic>))
          .toList(),
      workflows: (json['workflows'] as List<dynamic>)
          .map((e) => WorkflowTemplate.fromJson(e as Map<String, dynamic>))
          .toList(),
      organizationId: json['organizationId'] as String,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      expectedEndDate: json['expectedEndDate'] == null
          ? null
          : DateTime.parse(json['expectedEndDate'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      templateId: json['templateId'] as String?,
      createdBy: json['createdBy'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      typeSpecificFields:
          json['typeSpecificFields'] as Map<String, dynamic>? ?? const {},
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'clientId': instance.clientId,
      'client': instance.client,
      'type': _$ProjectTypeEnumMap[instance.type]!,
      'status': _$ProjectStatusEnumMap[instance.status]!,
      'phases': instance.phases,
      'milestones': instance.milestones,
      'members': instance.members,
      'workflows': instance.workflows,
      'organizationId': instance.organizationId,
      'value': instance.value,
      'description': instance.description,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'expectedEndDate': instance.expectedEndDate?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'templateId': instance.templateId,
      'createdBy': instance.createdBy,
      'metadata': instance.metadata,
      'typeSpecificFields': instance.typeSpecificFields,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$ProjectTypeEnumMap = {
  ProjectType.custom: 'custom',
  ProjectType.socialMedia: 'socialMedia',
  ProjectType.software: 'software',
  ProjectType.ecommerce: 'ecommerce',
  ProjectType.appDevelopment: 'appDevelopment',
  ProjectType.uiuxDesign: 'uiuxDesign',
  ProjectType.webDevelopment: 'webDevelopment',
  ProjectType.marketing: 'marketing',
  ProjectType.event: 'event',
  ProjectType.research: 'research',
  ProjectType.construction: 'construction',
  ProjectType.education: 'education',
  ProjectType.other: 'other',
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.planning: 'planning',
  ProjectStatus.active: 'active',
  ProjectStatus.inProgress: 'inProgress',
  ProjectStatus.onHold: 'onHold',
  ProjectStatus.completed: 'completed',
  ProjectStatus.cancelled: 'cancelled',
};
