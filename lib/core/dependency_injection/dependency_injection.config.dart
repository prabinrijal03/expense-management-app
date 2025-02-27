// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../domain/repositories/expense_repository.dart' as _i630;
import '../../domain/repositories/repositories.dart' as _i688;
import '../../domain/usecases/auth_usecase.dart' as _i856;
import '../../domain/usecases/expense_usecase.dart' as _i742;
import '../../presentation/bloc/auth_bloc/auth_bloc.dart' as _i125;
import '../../presentation/bloc/bloc/expense_bloc.dart' as _i471;
import 'dependency_injection.dart' as _i9;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i742.GenerateReportUseCase>(() => _i742.GenerateReportUseCase());
  gh.singleton<_i688.AuthRepository>(
      () => registerModule.provideAuthRepository());
  gh.singleton<_i630.ExpenseRepository>(
      () => registerModule.provideExpenseRepository());
  gh.factory<_i742.SubmitExpenseUseCase>(
      () => _i742.SubmitExpenseUseCase(gh<_i630.ExpenseRepository>()));
  gh.factory<_i742.GetExpensesUseCase>(
      () => _i742.GetExpensesUseCase(gh<_i630.ExpenseRepository>()));
  gh.factory<_i742.UpdateExpenseStatusUseCase>(
      () => _i742.UpdateExpenseStatusUseCase(gh<_i630.ExpenseRepository>()));
  gh.factory<_i742.GetExpensesForReportUseCase>(
      () => _i742.GetExpensesForReportUseCase(gh<_i630.ExpenseRepository>()));
  gh.factory<_i742.SyncPendingExpensesUseCase>(
      () => _i742.SyncPendingExpensesUseCase(gh<_i630.ExpenseRepository>()));
  gh.singleton<_i856.SignUpUseCase>(
      () => registerModule.provideSignUpUseCase(gh<_i688.AuthRepository>()));
  gh.singleton<_i856.SignInUseCase>(
      () => registerModule.provideSignInUseCase(gh<_i688.AuthRepository>()));
  gh.singleton<_i856.SignOutUseCase>(
      () => registerModule.provideSignOutUseCase(gh<_i688.AuthRepository>()));
  gh.factory<_i471.ExpenseBloc>(() => registerModule.provideExpenseBloc(
        gh<_i742.SubmitExpenseUseCase>(),
        gh<_i742.GetExpensesUseCase>(),
        gh<_i742.UpdateExpenseStatusUseCase>(),
        gh<_i742.GetExpensesForReportUseCase>(),
      ));
  gh.factory<_i125.AuthBloc>(() => registerModule.provideAuthBloc(
        gh<_i856.SignUpUseCase>(),
        gh<_i856.SignInUseCase>(),
        gh<_i856.SignOutUseCase>(),
      ));
  return getIt;
}

class _$RegisterModule extends _i9.RegisterModule {}
