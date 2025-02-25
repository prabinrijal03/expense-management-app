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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _navigateTo(context, 'admin'),
                child: const Text('Login as Admin'),
              ),
              ElevatedButton(
                onPressed: () => _navigateTo(context, 'manager'),
                child: const Text('Login as Manager'),
              ),
              ElevatedButton(
                onPressed: () => _navigateTo(context, 'employee'),
                child: const Text('Login as Employee'),
              ),
            ],
          ),
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
            TextField(decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(
              onPressed: () => bloc.add(AuthEvent.signIn('test@example.com', 'password')),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
