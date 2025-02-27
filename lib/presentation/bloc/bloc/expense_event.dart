part of 'expense_bloc.dart';

@freezed
class ExpenseEvent with _$ExpenseEvent {
  const factory ExpenseEvent.submit({
    required ExpenseEntity expense,
    required Uint8List? receipt,
  }) = _Submit;
  const factory ExpenseEvent.fetch({
    required String? userId,
    required String? status,
  }) = _Fetch;  
 
  const factory ExpenseEvent.updateStatus({
    required String expenseId,
    required String status,
  }) = _UpdateStatus;

}