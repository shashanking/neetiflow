import 'package:neetiflow/domain/entities/lead.dart';

class LeadConverter {
  /// Convert Lead to Lead (essentially a no-op conversion)
  static Lead convert(Lead lead) {
    return lead;
  }

  /// Simplified conversion methods that essentially return the input
  static Lead toEntity(Lead lead) => lead;
  static Lead toModel(Lead lead) => lead;
}
