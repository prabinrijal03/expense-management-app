import 'package:expense_management_app/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:expense_management_app/data/repositories/auth_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/repositories.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../domain/usecases/expense_usecase.dart';
import '../../presentation/bloc/bloc/expense_bloc.dart';
import 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void configureDependencies() => $initGetIt(getIt);

@module
abstract class RegisterModule {
  @singleton
  AuthRepository provideAuthRepository() => AuthRepositoryImpl();

  @singleton
  SignUpUseCase provideSignUpUseCase(AuthRepository repo) =>
      SignUpUseCase(repo);

  @singleton
  SignInUseCase provideSignInUseCase(AuthRepository repo) =>
      SignInUseCase(repo);

  @singleton
  SignOutUseCase provideSignOutUseCase(AuthRepository repo) =>
      SignOutUseCase(repo);

  @singleton
  ExpenseRepository provideExpenseRepository() => ExpenseRepositoryImpl();

  @factory
  AuthBloc provideAuthBloc(SignUpUseCase signUpUseCase,
          SignInUseCase signInUseCase, SignOutUseCase signOutUseCase) =>
      AuthBloc(signUpUseCase, signInUseCase, signOutUseCase);

  @factory
  ExpenseBloc provideExpenseBloc(
    SubmitExpenseUseCase submitUseCase,
    GetExpensesUseCase getExpensesUseCase,
    UpdateExpenseStatusUseCase updateExpenseStatusUseCase,
    GetExpensesForReportUseCase getExpensesForReportUseCase,
  ) =>
      ExpenseBloc(
        submitExpenseUseCase: submitUseCase,
        getExpensesUseCase: getExpensesUseCase,
        updateExpenseStatusUseCase: updateExpenseStatusUseCase,
        getExpensesForReportUseCase: getExpensesForReportUseCase,
      );
}
