import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/operations/project_template.dart';
import 'package:neetiflow/presentation/blocs/project_template/project_template_bloc.dart';
import 'package:neetiflow/presentation/widgets/projects/project_template_details.dart';
import 'package:neetiflow/presentation/widgets/projects/project_template_form.dart';
import 'package:neetiflow/injection.dart';

class ProjectTemplateList extends StatefulWidget {
  const ProjectTemplateList({
    super.key,
  });

  @override
  State<ProjectTemplateList> createState() => _ProjectTemplateListState();
}

class _ProjectTemplateListState extends State<ProjectTemplateList> {
  String _searchQuery = '';
  ProjectType? _selectedType;
  bool _showOnlyDerived = false;
  late final ProjectTemplateBloc _projectTemplateBloc;

  @override
  void initState() {
    super.initState();
    _projectTemplateBloc = getIt<ProjectTemplateBloc>()..add(const ProjectTemplateEvent.started());
  }

  @override
  void dispose() {
    _projectTemplateBloc.close();
    super.dispose();
  }

  Future<void> _showTemplateForm(BuildContext context, {ProjectTemplate? template}) async {
    print('Opening template form with template: ${template?.id}');
    
    await showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: _projectTemplateBloc,
        child: Dialog(
          child: Container(
            width: 800,
            height: 600,
            padding: const EdgeInsets.all(16),
            child: ProjectTemplateForm(
              template: template,
              onSubmit: (template) {
                print('Form submitted with template: ${template.id}');
                // Check if template has a valid ID (not empty and not a placeholder)
                if (template.id.isEmpty || template.id.startsWith('[#')) {
                  print('Creating new template');
                  _projectTemplateBloc.add(ProjectTemplateEvent.created(template.copyWith(id: '')));
                } else {
                  print('Updating template: ${template.id}');
                  _projectTemplateBloc.add(ProjectTemplateEvent.updated(template));
                }
                Navigator.of(dialogContext).pop();
                print('Dialog closed');
              },
              onCancel: () {
                Navigator.of(dialogContext).pop();
                print('Form cancelled');
              },
            ),
          ),
        ),
      ),
    );
    print('Dialog finished');
  }

  List<ProjectTemplate> _filterTemplates(List<ProjectTemplate> templates) {
    // Debug logging
    print('Total templates received: ${templates.length}');
    for (var template in templates) {
      print('Template: ${template.name}, ID: ${template.id}, Type: ${template.type}');
    }

    // Apply filters
    return templates.where((template) {
      // Search query filter
      final matchesSearch = _searchQuery.isEmpty || 
        template.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (template.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);

      // Type filter
      final matchesType = _selectedType == null || template.type == _selectedType;

      // Derived filter
      final matchesDerivedStatus = !_showOnlyDerived || template.parentTemplateId != null;

      return matchesSearch && matchesType && matchesDerivedStatus;
    }).toList();
  }

  Widget _buildTemplateCard(BuildContext context, ProjectTemplate template) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        title: Text(
          template.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              template.description ?? '',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                template.type.toString().split('.').last,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showTemplateForm(
                context,
                template: template,
              ),
              tooltip: 'Edit Template',
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Delete Template'),
                    content: Text('Are you sure you want to delete "${template.name}"?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          _projectTemplateBloc.add(ProjectTemplateEvent.deleted(template.id));
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Delete Template',
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: ProjectTemplateDetails(
                template: template,
                onEdit: () {
                  Navigator.pop(context);
                  _showTemplateForm(context, template: template);
                },
                onDelete: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Delete Template'),
                      content: Text('Are you sure you want to delete "${template.name}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          child: const Text('Cancel'),
                        ),
                        FilledButton(
                          onPressed: () {
                            _projectTemplateBloc.add(ProjectTemplateEvent.deleted(template.id));
                            Navigator.of(dialogContext).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                onClone: () {
                  Navigator.pop(context);
                  _projectTemplateBloc.add(
                        ProjectTemplateEvent.cloned(template),
                      );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showTemplateForm(context),
            tooltip: 'Create New Template',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search templates...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Type Filter Dropdown
                DropdownButton<ProjectType>(
                  hint: const Text('Filter by Type'),
                  value: _selectedType,
                  onChanged: (ProjectType? newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items: ProjectType.values
                      .map<DropdownMenuItem<ProjectType>>((ProjectType type) {
                    return DropdownMenuItem<ProjectType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
                // Derived Templates Toggle
                Row(
                  children: [
                    const Text('Show Derived'),
                    Switch(
                      value: _showOnlyDerived,
                      onChanged: (bool value) {
                        setState(() {
                          _showOnlyDerived = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Templates List
          Expanded(
            child: BlocBuilder<ProjectTemplateBloc, ProjectTemplateState>(
              bloc: _projectTemplateBloc,
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text('Initialize templates')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loaded: (templates) {
                    final filteredTemplates = _filterTemplates(templates);
                    
                    if (filteredTemplates.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.folder_open,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No templates found',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty 
                                ? 'No templates match your search' 
                                : 'Create your first project template',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => _showTemplateForm(context),
                              child: const Text('Create Template'),
                            ),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTemplates.length,
                      itemBuilder: (context, index) {
                        final template = filteredTemplates[index];
                        return _buildTemplateCard(context, template);
                      },
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 80,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error Loading Templates',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _projectTemplateBloc.add(const ProjectTemplateEvent.started()),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTemplateForm(context),
        tooltip: 'Create New Template',
        child: const Icon(Icons.add),
      ),
    );
  }
}
