import 'package:neetiflow/domain/entities/lead.dart' as entities;
import 'package:neetiflow/domain/models/lead_model.dart' as models;
import 'package:neetiflow/core/utils/enum_utils.dart';

class LeadConverter {
  /// Convert LeadModel to Lead entity
  static entities.Lead toEntity(models.LeadModel model) {
    final entityStatus = entities.LeadStatus.values.firstWhere(
      (s) => EnumUtils.toShortString(s) == EnumUtils.toShortString(model.status),
      orElse: () => entities.LeadStatus.cold,
    );

    final entityProcessStatus = entities.ProcessStatus.values.firstWhere(
      (s) => EnumUtils.toShortString(s) == EnumUtils.toShortString(model.processStatus),
      orElse: () => entities.ProcessStatus.fresh,
    );

    final nameParts = (model.name ?? '').split(' ');
    final hasLastName = nameParts.length > 1;

    return entities.Lead(
      id: model.id ?? '',
      uid: model.id ?? '',
      firstName: nameParts.isNotEmpty ? nameParts[0] : '',
      lastName: hasLastName ? nameParts.sublist(1).join(' ') : '',
      phone: model.phone ?? '',
      email: model.email ?? '',
      subject: model.company ?? '',
      message: '',
      status: entityStatus,
      processStatus: entityProcessStatus,
      createdAt: model.createdAt,
      metadata: const {},
      segments: const [],
    );
  }

  /// Convert Lead entity to LeadModel
  static models.LeadModel toModel(entities.Lead lead) {
    final modelStatus = models.LeadStatus.values.firstWhere(
      (s) => EnumUtils.toShortString(s) == EnumUtils.toShortString(lead.status),
      orElse: () => models.LeadStatus.cold,
    );

    final modelProcessStatus = models.ProcessStatus.values.firstWhere(
      (s) => EnumUtils.toShortString(s) == EnumUtils.toShortString(lead.processStatus),
      orElse: () => models.ProcessStatus.fresh,
    );

    return models.LeadModel(
      id: lead.id,
      name: getLeadName(lead),
      email: lead.email,
      phone: lead.phone,
      company: lead.subject,
      status: modelStatus,
      processStatus: modelProcessStatus,
      createdAt: lead.createdAt,
    );
  }

  /// Generate full lead name
  static String getLeadName(entities.Lead lead) {
    return '${lead.firstName} ${lead.lastName}'.trim();
  }
}
