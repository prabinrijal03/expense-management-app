import 'package:expense_management_app/presentation/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dependency_injection/dependency_injection.dart';
import '../../bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Role-Based Authentication')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            state.when(
                initial: () {},
                loading: () => const CircularProgressIndicator(),
                authenticated: (user) {
                  user.role == 'admin'
                      ? AdminPage()
                      : print("this is ${user.role}");
                },
                unauthenticated: () {
                  print("error user credentials");
                },
                error: (message) {
                  print(message);
                });
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                      decoration: const InputDecoration(labelText: 'Email')),
                  TextField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(AuthEvent.signUp(
                          email: 'tes1t@gmail.com',
                          password: "12345678",
                          role: "user"));
                    },
                    child: const Text('Register as Admin'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(AuthEvent.signIn(
                        email: 'test@gmail.com',
                        password: "12345678",
                      ));
                    },
                    child: const Text('Login as Manager'),
                  ),
                  ElevatedButton(
                    onPressed: () => _navigateTo(context, 'employee'),
                    child: const Text('Login as Employee'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String role) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(role: role),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final String role;
  const LoginPage({required this.role, super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Login as $role')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            // ElevatedButton(
            //   onPressed: () =>
            //       bloc.add(AuthEvent.signIn('test@example.com', 'password')),
            //   child: const Text('Login'),
            // ),
          ],
        ),
      ),
    );
  }
}
