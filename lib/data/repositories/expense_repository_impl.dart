import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';

import '../../core/errors/failure.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_model/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final HiveInterface hive = Hive;
  final Connectivity connectivity = Connectivity();

  @override
  Future<void> submitExpense(ExpenseEntity expense, Uint8List? receipt) async {
    try {
      final isConnected =
          await connectivity.checkConnectivity() != ConnectivityResult.none;

      if (!isConnected) {
        await hive.box('pending_expenses').add(expense);
        return;
      }
      final docRef = _firestore.collection('expenses').doc();
      final newExpense = (expense as ExpenseModel).copyWith(id: docRef.id);

      if (receipt != null) {
        final ref = _storage.ref().child('receipts/${docRef.id}');
        await ref.putData(receipt);
        final updatedExpense = newExpense.copyWith(
          receiptUrl: await ref.getDownloadURL(),
          status: 'pending',
        );
        await docRef.set(updatedExpense.toJson());
      } else {
        await docRef.set(newExpense.toJson());
      }
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> syncPendingExpenses() async {
    final pendingBox = hive.box('pending_expenses');
    for (var expense in pendingBox.values) {
      await submitExpense(expense as ExpenseEntity, null);
    }
    await pendingBox.clear();
  }

  @override
  Stream<List<ExpenseEntity>> getExpenses(
    String? userId,
    String? status,
    int limit,
    DocumentSnapshot? lastDocument,
  ) {
    Query query = _firestore
        .collection('expenses')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (userId != null) query = query.where('userId', isEqualTo: userId);
    if (status != null) query = query.where('status', isEqualTo: status);
    if (lastDocument != null) query = query.startAfterDocument(lastDocument);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ExpenseModel.fromFirestore(doc)).toList());
  }

  @override
  Future<void> updateExpenseStatus(String expenseId, String status) async {
    try {
      await _firestore.collection('expenses').doc(expenseId).update({
        'status': status,
        'reviewedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ExpenseEntity>> getExpensesForReport({
    required DateTime start,
    required DateTime end,
    String? userId,
  }) async {
    try {
      final query = _firestore
          .collection('expenses')
          .where('timestamp', isGreaterThan: start)
          .where('timestamp', isLessThan: end);

      if (userId != null) query.where('userId', isEqualTo: userId);

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
