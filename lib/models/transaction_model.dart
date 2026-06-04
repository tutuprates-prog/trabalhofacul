// lib/models/transaction_model.dart
enum TransactionType { income, expense }

class TransactionModel {
  final int? id;
  final int userId;
  final String title;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? description;

  const TransactionModel({
    this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.description,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'amount': amount,
        'date': date.toIso8601String(),
        'type': type.name,
        'category': category,
        'description': description,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) => TransactionModel(
        id: map['id'] as int?,
        userId: map['user_id'] as int,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        date: DateTime.parse(map['date'] as String),
        type: TransactionType.values.byName(map['type'] as String),
        category: map['category'] as String,
        description: map['description'] as String?,
      );

  TransactionModel copyWith({
    int? id,
    int? userId,
    String? title,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? description,
  }) =>
      TransactionModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        type: type ?? this.type,
        category: category ?? this.category,
        description: description ?? this.description,
      );

  static const List<String> incomeCategories = [
    'Salário',
    'Freelance',
    'Investimentos',
    'Presente',
    'Outros',
  ];

  static const List<String> expenseCategories = [
    'Alimentação',
    'Transporte',
    'Moradia',
    'Saúde',
    'Lazer',
    'Educação',
    'Roupas',
    'Outros',
  ];
}
