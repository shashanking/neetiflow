import 'package:flutter/material.dart';
import 'package:neetiflow/domain/entities/operations/project.dart';

class ProjectListForm {
  final TextEditingController searchController;
  final ProjectStatus? statusFilter;
  final String? clientFilter;
  final DateTimeRange? dateFilter;

  ProjectListForm({
    TextEditingController? searchController,
    this.statusFilter,
    this.clientFilter,
    this.dateFilter,
  }) : searchController = searchController ?? TextEditingController();

  factory ProjectListForm.initial() {
    return ProjectListForm(
      searchController: TextEditingController(),
    );
  }

  void dispose() {
    searchController.dispose();
  }

  ProjectListForm copyWith({
    TextEditingController? searchController,
    ProjectStatus? statusFilter,
    String? clientFilter,
    DateTimeRange? dateFilter,
  }) {
    return ProjectListForm(
      searchController: searchController ?? this.searchController,
      statusFilter: statusFilter ?? this.statusFilter,
      clientFilter: clientFilter ?? this.clientFilter,
      dateFilter: dateFilter ?? this.dateFilter,
    );
  }
}
