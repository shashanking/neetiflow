import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/lead.dart';

class LeadStatusColors {
  static Color getLeadStatusColor(LeadStatus status) {
    switch (status) {
      case LeadStatus.hot:
        return Colors.red.shade400;
      case LeadStatus.warm:
        return Colors.orange.shade400;
      case LeadStatus.cold:
        return Colors.blue.shade400;
    }
  }

  static Color getProcessStatusColor(ProcessStatus status) {
    switch (status) {
      case ProcessStatus.fresh:
        return Colors.green.shade400;
      case ProcessStatus.inProgress:
        return Colors.amber.shade400;
      case ProcessStatus.completed:
        return Colors.indigo.shade400;
      case ProcessStatus.rejected:
        return Colors.grey.shade400;
    }
  }

  static Color getLeadStatusBackgroundColor(LeadStatus status) {
    return getLeadStatusColor(status).withOpacity(0.1);
  }

  static Color getProcessStatusBackgroundColor(ProcessStatus status) {
    return getProcessStatusColor(status).withOpacity(0.1);
  }
}
