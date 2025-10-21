enum ExpenseCategory {
  transportation,
  maintenance,
  utilities,
  salary,
  marketing,
  supplies,
  other,
}

class ExpenseModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
  final String? receipt;
  final String createdBy;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.receipt,
    required this.createdBy,
    required this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      category: ExpenseCategory.values.firstWhere(
        (e) => e.toString() == 'ExpenseCategory.${json['category']}',
        orElse: () => ExpenseCategory.other,
      ),
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      receipt: json['receipt'],
      createdBy: json['createdBy'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category.toString().split('.').last,
      'date': date.toIso8601String(),
      'receipt': receipt,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? title,
    String? description,
    double? amount,
    ExpenseCategory? category,
    DateTime? date,
    String? receipt,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      receipt: receipt ?? this.receipt,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
