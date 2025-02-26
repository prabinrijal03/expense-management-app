import 'dart:typed_data';

import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
 Stream<List<ExpenseEntity>> getExpenses(String? userId,  String? status);
   Future<void> submitExpense(ExpenseEntity expense, Uint8List? receipt);
}
