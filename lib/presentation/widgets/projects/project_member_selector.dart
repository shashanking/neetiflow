import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/employee.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';
import 'package:neetiflow/presentation/widgets/common/employee_search.dart';

class ProjectMemberSelector extends StatefulWidget {
  final void Function(List<ProjectMember> members) onMembersSelected;
  final List<ProjectMember>? initialMembers;

  const ProjectMemberSelector({
    Key? key,
    required this.onMembersSelected,
    this.initialMembers,
  }) : super(key: key);

  @override
  State<ProjectMemberSelector> createState() => _ProjectMemberSelectorState();
}

class _ProjectMemberSelectorState extends State<ProjectMemberSelector> {
  List<ProjectMember> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialMembers != null) {
      _selectedMembers = List.from(widget.initialMembers!);
    }
  }

  void _addMember(Employee employee) {
    // Check if employee is already added
    if (_selectedMembers.any((m) => m.employeeId == employee.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee already added to project')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        String selectedRole = 'Team Member';
        ProjectAccess selectedAccess = ProjectAccess.view;

        return AlertDialog(
          title: const Text('Add Team Member'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${employee.firstName} ${employee.lastName}'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                value: selectedRole,
                items: const [
                  DropdownMenuItem(value: 'Project Manager', child: Text('Project Manager')),
                  DropdownMenuItem(value: 'Team Lead', child: Text('Team Lead')),
                  DropdownMenuItem(value: 'Team Member', child: Text('Team Member')),
                ],
                onChanged: (value) {
                  selectedRole = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectAccess>(
                decoration: const InputDecoration(
                  labelText: 'Access Level',
                  border: OutlineInputBorder(),
                ),
                value: selectedAccess,
                items: ProjectAccess.values.map((access) {
                  return DropdownMenuItem(
                    value: access,
                    child: Text(access.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedAccess = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newMember = ProjectMember(
                  employeeId: employee.id!,
                  employeeName: '${employee.firstName} ${employee.lastName}',
                  role: selectedRole,
                  access: selectedAccess,
                  joinedAt: DateTime.now(),
                  department: employee.departmentId,
                );

                setState(() {
                  _selectedMembers.add(newMember);
                });

                widget.onMembersSelected(_selectedMembers);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeMember(String employeeId) {
    setState(() {
      _selectedMembers.removeWhere((m) => m.employeeId == employeeId);
    });
    widget.onMembersSelected(_selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Team Members',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        
        // Employee Search
        EmployeeSearch(
          onEmployeeSelected: _addMember,
          excludeIds: _selectedMembers.map((m) => m.employeeId).toList(),
        ),
        const SizedBox(height: 16),

        // Selected Members List
        if (_selectedMembers.isNotEmpty) ...[
          const Text(
            'Selected Team Members:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedMembers.length,
            itemBuilder: (context, index) {
              final member = _selectedMembers[index];
              return ListTile(
                title: Text(member.employeeName),
                subtitle: Text('${member.role} • ${member.access.toString().split('.').last}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _removeMember(member.employeeId),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
