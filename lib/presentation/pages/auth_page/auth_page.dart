import 'package:expense_management_app/presentation/pages/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/dependency_injection/dependency_injection.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String selectedRole = 'employee';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Role-Based Authentication')),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              loading: () => showDialog(
                context: context,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              ),
              registered: (user) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Registered as ${user.role}')),
                );
              },
              authenticated: (user) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(user: user)),
                );
              },
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
                  DropdownButtonFormField(
                    value: selectedRole,
                    items: ['admin', 'manager', 'employee']
                        .map((role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) => selectedRole = value.toString(),
                  ),
                  ElevatedButton(
                    onPressed: () => _handleSignUp(context),
                    child: const Text('Register'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<AuthBloc>(context).add(AuthEvent.signIn(
                        email: emailController.text,
                        password: passwordController.text,
                      ));
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) {
    context.read<AuthBloc>().add(AuthEvent.signUp(
          email: emailController.text,
          password: passwordController.text,
          role: selectedRole,
        ));
  }
}
