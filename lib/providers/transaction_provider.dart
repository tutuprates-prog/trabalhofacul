// lib/providers/transaction_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database_helper.dart';
import '../models/transaction_model.dart';
import 'auth_provider.dart';

class TransactionState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final String? error;
  final String filter; // 'all' | 'income' | 'expense'

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.filter = 'all',
  });

  List<TransactionModel> get filtered {
    switch (filter) {
      case 'income':
        return transactions.where((t) => t.isIncome).toList();
      case 'expense':
        return transactions.where((t) => t.isExpense).toList();
      default:
        return transactions;
    }
  }

  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.isExpense)
      .fold(0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  TransactionState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    String? error,
    String? filter,
  }) =>
      TransactionState(
        transactions: transactions ?? this.transactions,
        isLoading: isLoading ?? this.isLoading,
        error: error,
        filter: filter ?? this.filter,
      );
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final DatabaseHelper _db;
  final int userId;

  TransactionNotifier(this._db, this.userId) : super(const TransactionState()) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final list = await _db.getTransactionsByUser(userId);
      state = state.copyWith(transactions: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> add(TransactionModel tx) async {
    final id = await _db.insertTransaction(tx);
    final saved = tx.copyWith(id: id);
    state = state.copyWith(transactions: [saved, ...state.transactions]);
  }

  Future<void> update(TransactionModel tx) async {
    await _db.updateTransaction(tx);
    state = state.copyWith(
      transactions: state.transactions.map((t) => t.id == tx.id ? tx : t).toList(),
    );
  }

  Future<void> delete(int id) async {
    await _db.deleteTransaction(id);
    state = state.copyWith(
      transactions: state.transactions.where((t) => t.id != id).toList(),
    );
  }

  void setFilter(String filter) => state = state.copyWith(filter: filter);

  Future<void> refresh() => _load();
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  final user = ref.watch(authProvider).user;
  return TransactionNotifier(DatabaseHelper.instance, user?.id ?? 0);
});
