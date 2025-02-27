import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usecases/auth_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc(this.signUpUseCase, this.signInUseCase, this.signOutUseCase)
      : super(const AuthState.initial()) {
    on<_SignUp>((event, emit) async {
      emit(const AuthState.loading());

      final user = await signUpUseCase(
          SignUpParams(event.email, event.password, event.role));

      if (user != null) {
        emit(AuthState.registered(user));
      } else {
        emit(const AuthState.error("Signup Failed"));
      }
    });

    on<_SignIn>((event, emit) async {
      emit(const AuthState.loading());

      final user =
          await signInUseCase(SignInParams(event.email, event.password));

      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        emit(const AuthState.error("Login Failed"));
      }
    });

    on<_SignOut>((event, emit) async {
      await signOutUseCase(NoParams());
      emit(const AuthState.unauthenticated());
    });
  }
}
