class ChecklistItem {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String category;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChecklistItem({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.isCompleted,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      isCompleted: json['is_completed'] ?? false,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      createdAt: json['created_at'] != null 
          ? (json['created_at'] is String 
              ? DateTime.parse(json['created_at'])
              : (json['created_at']).toDate())
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? (json['updated_at'] is String 
              ? DateTime.parse(json['updated_at'])
              : (json['updated_at']).toDate())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'is_completed': isCompleted,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ChecklistItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? category,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
