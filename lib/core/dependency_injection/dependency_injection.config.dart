// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../domain/repositories/repositories.dart' as _i688;
import '../../domain/usecases/auth_usecase.dart' as _i856;
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
  gh.singleton<_i688.AuthRepository>(
      () => registerModule.provideAuthRepository());
  gh.singleton<_i856.SignUpUseCase>(
      () => registerModule.provideSignUpUseCase(gh<_i688.AuthRepository>()));
  gh.singleton<_i856.SignInUseCase>(
      () => registerModule.provideSignInUseCase(gh<_i688.AuthRepository>()));
  return getIt;
}

class _$RegisterModule extends _i9.RegisterModule {}
