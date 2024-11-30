import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/data/repositories/employee_timeline_repository.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/lead.dart';
import 'package:neetiflow/presentation/blocs/auth/auth_bloc.dart';
import 'package:neetiflow/presentation/blocs/employees/employees_bloc.dart';
import 'package:neetiflow/presentation/blocs/leads/leads_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/timeline_event.dart';

class LeadAssignmentDialog extends StatefulWidget {
  final Lead lead;
  final LeadsBloc leadsBloc;

  const LeadAssignmentDialog({
    super.key,
    required this.lead,
    required this.leadsBloc,
  });

  @override
  State<LeadAssignmentDialog> createState() => _LeadAssignmentDialogState();
}

class _LeadAssignmentDialogState extends State<LeadAssignmentDialog> {
  Employee? _selectedEmployee;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.employee.companyId != null) {
      context.read<EmployeesBloc>().add(LoadEmployees(authState.employee.companyId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !_isAssigning,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.lead.metadata?['assignedEmployeeId'] != null 
                    ? 'Reassign Lead' 
                    : 'Assign Lead',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is EmployeesError) {
                    return Center(
                      child: Text(
                        'Error loading employees: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (state is EmployeesLoaded) {
                    // Filter out currently assigned employee from the list
                    final employees = state.employees.where((e) => 
                      e.id != widget.lead.metadata?['assignedEmployeeId']
                    ).toList();

                    if (employees.isEmpty) {
                      return const Center(
                        child: Text('No employees available for assignment'),
                      );
                    }

                    return DropdownButtonFormField<Employee>(
                      value: _selectedEmployee,
                      decoration: const InputDecoration(
                        labelText: 'Select Employee',
                        border: OutlineInputBorder(),
                      ),
                      items: employees.map((employee) {
                        return DropdownMenuItem(
                          value: employee,
                          child: Text('${employee.firstName} ${employee.lastName}'),
                        );
                      }).toList(),
                      onChanged: (Employee? employee) {
                        setState(() {
                          _selectedEmployee = employee;
                        });
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isAssigning ? null : () {
                      if (mounted) Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isAssigning || _selectedEmployee == null 
                        ? null 
                        : _assignLead,
                    child: _isAssigning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.lead.metadata?['assignedEmployeeId'] != null 
                            ? 'Reassign' 
                            : 'Assign'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _assignLead() async {
    if (_selectedEmployee == null || _isAssigning) return;

    setState(() {
      _isAssigning = true;
    });

    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        throw Exception('User not authenticated');
      }

      final now = DateTime.now();
      
      // Create lead timeline event
      final leadTimelineEvent = TimelineEvent(
        id: const Uuid().v4(),
        leadId: widget.lead.id,
        title: widget.lead.metadata?['assignedEmployeeId'] != null 
            ? 'Lead Reassigned' 
            : 'Lead Assigned',
        description: widget.lead.metadata?['assignedEmployeeId'] != null
            ? 'Lead reassigned to ${_selectedEmployee!.firstName} ${_selectedEmployee!.lastName}'
            : 'Lead assigned to ${_selectedEmployee!.firstName} ${_selectedEmployee!.lastName}',
        timestamp: now,
        category: 'assignment',
        metadata: {
          'assignedEmployeeId': _selectedEmployee!.id ?? '',
          'assignedByEmployeeId': authState.employee.id ?? '',
          if (widget.lead.metadata?['assignedEmployeeId'] != null)
            'old_assignedEmployeeId': widget.lead.metadata!['assignedEmployeeId'],
          'type': widget.lead.metadata?['assignedEmployeeId'] != null 
              ? 'lead_reassignment' 
              : 'lead_assignment',
        },
      );

      // Create employee timeline event
      final employeeTimelineEvent = EmployeeTimelineEvent(
        id: const Uuid().v4(),
        employeeId: _selectedEmployee!.id ?? '',
        title: 'New Lead Assigned',
        description: 'Assigned lead: ${widget.lead.firstName} ${widget.lead.lastName}',
        timestamp: now,
        category: 'lead_assignment',
        metadata: {
          'leadId': widget.lead.id,
          'leadName': '${widget.lead.firstName} ${widget.lead.lastName}',
          'assignedByEmployeeId': authState.employee.id ?? '',
          'assignedByName': '${authState.employee.firstName} ${authState.employee.lastName}',
          if (widget.lead.metadata?['assignedEmployeeId'] != null)
            'isReassignment': true,
        },
      );

      final updatedLead = widget.lead.copyWith(
        metadata: {
          ...widget.lead.metadata ?? {},
          'assignedEmployeeId': _selectedEmployee!.id,
          'assignedAt': now.toIso8601String(),
          'assignedByEmployeeId': authState.employee.id,
        },
      );

      try {
        debugPrint('Updating lead with LeadsBloc');
        // Update lead and create lead timeline event
        widget.leadsBloc.add(UpdateLead(
          lead: updatedLead,
          timelineEvent: leadTimelineEvent,
        ));

        // Create employee timeline event
        final employeeTimelineRepo = context.read<EmployeeTimelineRepository>();
        await employeeTimelineRepo.addTimelineEvent(
          authState.employee.companyId ?? '',
          employeeTimelineEvent,
        );
      } catch (e) {
        debugPrint('Error updating lead: $e');
        rethrow;
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      debugPrint('Error in _assignLead: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error assigning lead: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }
}
