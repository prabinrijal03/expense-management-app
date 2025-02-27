import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  Stream<List<ExpenseEntity>> getExpenses(String? userId, String? status,
      int limit, DocumentSnapshot? lastDocument);
  Future<void> submitExpense(ExpenseEntity expense, Uint8List? receipt);
  Future<void> updateExpenseStatus(String expenseId, String status);
  Future<List<ExpenseEntity>> getExpensesForReport({
    required DateTime start,
    required DateTime end,
    String? userId,
  });
  Future<void> syncPendingExpenses();
}
