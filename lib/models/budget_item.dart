class BudgetItem {
  final String id;
  final String userId;
  final String category;
  final double allocatedAmount;
  final double spentAmount;
  final double percentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  BudgetItem({
    required this.id,
    required this.userId,
    required this.category,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.percentage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      id: json['id'],
      userId: json['user_id'],
      category: json['category'],
      allocatedAmount: (json['allocated_amount'] ?? 0).toDouble(),
      spentAmount: (json['spent_amount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category': category,
      'allocated_amount': allocatedAmount,
      'spent_amount': spentAmount,
      'percentage': percentage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get remainingAmount => allocatedAmount - spentAmount;

  BudgetItem copyWith({
    String? id,
    String? userId,
    String? category,
    double? allocatedAmount,
    double? spentAmount,
    double? percentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      percentage: percentage ?? this.percentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
