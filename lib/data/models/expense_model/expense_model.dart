import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
class ExpenseModel with _$ExpenseModel {
  factory ExpenseModel({
    required String id,
    required String userId,
    required String title,
    required String description,
    required double amount,
    required String receiptUrl,
    required DateTime timestamp,
    required String status, 
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ExpenseModel(
      id: doc.id,
      userId: data['userId'],
      title: data['title'],
      description: data['description'],
      amount: data['amount'],
      receiptUrl: data['receiptUrl'],
      timestamp: data['timestamp'].toDate(),
      status: data['status'],
    );
  }
}