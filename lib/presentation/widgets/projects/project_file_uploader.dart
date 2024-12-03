import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_bloc.dart';
import 'package:neetiflow/presentation/blocs/project/project_event.dart';

import '../../blocs/project/project_state.dart';

class ProjectFileUploader extends StatelessWidget {
  final String projectId;

  const ProjectFileUploader({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text('Project Files'),
          trailing: IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: () => _pickAndUploadFile(context),
          ),
        ),
        BlocBuilder<ProjectBloc, ProjectState>(
          builder: (context, state) {
            return state.maybeMap(
              loaded: (state) {
                final projectFiles = state.currentProject?.metadata['files'] ?? [];
                if (projectFiles.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No files uploaded yet'),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projectFiles.length,
                  itemBuilder: (context, index) {
                    final file = projectFiles[index];
                    return ListTile(
                      leading: Icon(_getFileIcon(file['type'] ?? '')),
                      title: Text(file['name'] ?? 'Unknown File'),
                      subtitle: Text(_formatFileSize(file['size'] ?? 0)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              // TODO: Implement file download
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showDeleteConfirmation(context, file);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickAndUploadFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          context.read<ProjectBloc>().add(
                ProjectEvent.fileUploaded(
                  projectId: projectId,
                  fileData: file.bytes!.toString(),
                ),
              );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context, dynamic file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Are you sure you want to delete ${file['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProjectBloc>().add(
                    ProjectEvent.fileDeleted(
                      projectId: projectId,
                      fileId: file['id'],
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
