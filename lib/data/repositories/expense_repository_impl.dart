import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/errors/failure.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> submitExpense(ExpenseEntity expense, Uint8List? receipt) async {
    try {
      if (receipt != null) {
        final ref = _storage.ref().child('receipts/${expense.id}');
        await ref.putData(receipt);
        final updatedExpense = (expense as ExpenseModel)
            .copyWith(receiptUrl: await ref.getDownloadURL());
        await _firestore
            .collection('expenses')
            .doc(updatedExpense.id)
            .set(updatedExpense.toJson());
      } else {
        await _firestore
            .collection('expenses')
            .doc(expense.id)
            .set((expense as ExpenseModel).toJson());
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Stream<List<ExpenseEntity>> getExpenses(String? userId, String? status) {
    Query query = _firestore.collection('expenses');
    if (userId != null) query = query.where('userId', isEqualTo: userId);
    if (status != null) query = query.where('status', isEqualTo: status);

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc) as ExpenseEntity)
        .toList());
  }
}
