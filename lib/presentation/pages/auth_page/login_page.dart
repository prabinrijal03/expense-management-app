import 'package:expense_management_app/core/dependency_injection/dependency_injection.dart';
import 'package:expense_management_app/presentation/pages/auth_page/register_page.dart';
import 'package:expense_management_app/presentation/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
          body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            loading: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  });
            },
            authenticated: (user) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomePage(
                  user: user,
                );
              }));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Welcome ${user.email}')),
              );
            },
            unauthenticated: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Invalid credentials')),
            ),
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
                TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthEvent.signIn(
                        email: emailController.text,
                        password: passwordController.text));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return RegisterPage();
                    }));
                  },
                  child: const Text('Register'),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
