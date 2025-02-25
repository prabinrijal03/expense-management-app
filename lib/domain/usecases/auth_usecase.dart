

import '../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/repositories.dart';

class SignUpUseCase extends UseCase<UserEntity?, SignUpParams> {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<UserEntity?> call(SignUpParams params) async {
    return await repository.signUp(params.email, params.password, params.role);
  }
}

class SignInUseCase extends UseCase<UserEntity?, SignInParams> {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  @override
  Future<UserEntity?> call(SignInParams params) async {
    return await repository.signIn(params.email, params.password);
  }
}

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    await repository.signOut();
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String role;
  SignUpParams(this.email, this.password, this.role);
}

class SignInParams {
  final String email;
  final String password;
  SignInParams(this.email, this.password);
}

class NoParams {}
