enum TaskPriority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, review, completed, archived }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String assignedTo;
  final String? projectId;
  final List<String> tags;
  final List<String> attachments;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedTo,
    this.projectId,
    required this.tags,
    required this.attachments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${json['priority']}',
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${json['status']}',
      ),
      assignedTo: json['assignedTo'] as String,
      projectId: json['projectId'] as String?,
      tags: List<String>.from(json['tags'] as List),
      attachments: List<String>.from(json['attachments'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'assignedTo': assignedTo,
      'projectId': projectId,
      'tags': tags,
      'attachments': attachments,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
