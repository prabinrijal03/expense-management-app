import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:expense_management_app/domain/usecases/expense_usecase.dart';

import '../../../domain/entities/expense_entity.dart';

part 'expense_event.dart';
part 'expense_state.dart';
part 'expense_bloc.freezed.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final SubmitExpenseUseCase submitExpenseUseCase;
  final GetExpensesUseCase getExpensesUseCase;
  final UpdateExpenseStatusUseCase updateExpenseStatusUseCase;
  final GetExpensesForReportUseCase getExpensesForReportUseCase;
  Stream<List<ExpenseEntity>> get expenseStream => _expenseStreamController.stream;
  final _expenseStreamController = StreamController<List<ExpenseEntity>>();
   List<ExpenseEntity> get expenseData => _expenseData;
  final List<ExpenseEntity> _expenseData = [];

   

  ExpenseBloc({
    required this.submitExpenseUseCase,
    required this.getExpensesUseCase,
    required this.updateExpenseStatusUseCase,
    required this.getExpensesForReportUseCase,
  }) : super(const ExpenseState.initial()) {
    on<ExpenseEvent>((event, emit) async {
      await event.map(
        submit: (e) async => await _handleSubmit(e, emit),
        fetch: (e) async => await _handleFetch(e, emit),
        updateStatus: (e) async => await _handleUpdateStatus(e, emit),
         
      );
    });
  }

  Future<void> _handleSubmit(_Submit event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseState.submitting());
    try {
      await submitExpenseUseCase(SubmitExpenseParams(event.expense, event.receipt));
      emit(const ExpenseState.submitSuccess());
    } catch (e) {
      emit(ExpenseState.error(e.toString()));
    }
  }

  Future<void> _handleFetch(_Fetch event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseState.loading());
    try {
      final stream = await getExpensesUseCase(GetExpensesParams(
        userId: event.userId,
        status: event.status,
      ));
      emit(ExpenseState.loaded(stream));
    } catch (e) {
      emit(ExpenseState.error(e.toString()));
    }
  }
   
  Future<void> _handleUpdateStatus(_UpdateStatus event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseState.submitting());
    try {
      
      await updateExpenseStatusUseCase(UpdateStatusParams(
        expenseId: event.expenseId,
        status: event.status,
      ));
      emit(const ExpenseState.submitSuccess());
    } catch (e) {
      emit(ExpenseState.error(e.toString()));
    }
  }
}