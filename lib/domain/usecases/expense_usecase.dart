import 'dart:io';
import 'dart:typed_data';

import 'package:expense_management_app/core/usecase/usecase.dart';
import 'package:expense_management_app/domain/entities/expense_entity.dart';
import 'package:expense_management_app/domain/repositories/expense_repository.dart';
import 'package:expense_management_app/domain/usecases/auth_usecase.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class SubmitExpenseUseCase extends UseCase<void, SubmitExpenseParams> {
  final ExpenseRepository repository;
  SubmitExpenseUseCase(this.repository);

  @override
  Future<void> call(SubmitExpenseParams params) async {
    return await repository.submitExpense(params.expense, params.receipt);
  }
}

@injectable
class GetExpensesUseCase
    extends UseCase<Stream<List<ExpenseEntity>>, GetExpensesParams> {
  final ExpenseRepository repository;
  GetExpensesUseCase(this.repository);

  @override
  Future<Stream<List<ExpenseEntity>>> call(GetExpensesParams params) async {
    return Future.value(
        repository.getExpenses(params.userId, params.status, 10, null));
  }
}

@injectable
class UpdateExpenseStatusUseCase extends UseCase<void, UpdateStatusParams> {
  final ExpenseRepository repository;
  UpdateExpenseStatusUseCase(this.repository);

  @override
  Future<void> call(UpdateStatusParams params) async {
    if (params.expenseId == null || params.status == null) {
      throw ArgumentError('expenseId and status cannot be null');
    }
    return await repository.updateExpenseStatus(
        params.expenseId!, params.status!);
  }
}

@injectable
class GetExpensesForReportUseCase
    extends UseCase<List<ExpenseEntity>, GetExpensesForReportParams> {
  final ExpenseRepository repository;
  GetExpensesForReportUseCase(this.repository);

  @override
  Future<List<ExpenseEntity>> call(GetExpensesForReportParams params) async {
    return await repository.getExpensesForReport(
      start: params.start,
      end: params.end,
      userId: params.userId,
    );
  }
}

@injectable
class GenerateReportUseCase {
  late final ExpenseRepository repository;

  Future<File> call(ReportParams params) async {
    final expenses = await repository.getExpensesForReport(
      start: params.startDate,
      end: params.endDate,
      userId: params.userId,
    );

    final csvData = _generateCSV(expenses);
    return _saveCSVFile(csvData);
  }

  Future<File> _saveCSVFile(String csvData) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/report.csv';
    final file = File(path);
    return await file.writeAsString(csvData);
  }

  String _generateCSV(List<ExpenseEntity> expenses) {
    final buffer = StringBuffer()..writeln('Title,Amount,Status,Date');

    for (final expense in expenses) {
      buffer.writeln(
          '${expense.title},${expense.amount},${expense.status},${expense.timestamp}');
    }

    return buffer.toString();
  }
}

@injectable
class SyncPendingExpensesUseCase extends UseCase<void, NoParams> {
  final ExpenseRepository repository;
  SyncPendingExpensesUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.syncPendingExpenses();
  }
}

class ReportParams {
  final DateTime startDate;
  final DateTime endDate;
  final String? userId;

  ReportParams({
    required this.startDate,
    required this.endDate,
    this.userId,
  });
}

class GetExpensesForReportParams {
  final DateTime start;
  final DateTime end;
  final String? userId;

  GetExpensesForReportParams({
    required this.start,
    required this.end,
    this.userId,
  });
}

class UpdateStatusParams {
  final String? expenseId;
  final String? status;
  UpdateStatusParams({this.expenseId, this.status});
}

class SubmitExpenseParams {
  final ExpenseEntity expense;
  final Uint8List? receipt;

  SubmitExpenseParams(this.expense, this.receipt);
}

class GetExpensesParams {
  final String? userId;
  final String? status;

  GetExpensesParams({this.userId, this.status});
}
