
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final String role;

  LoginPage({super.key, required this.role});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email')),
          TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(
                AuthEvent.signIn(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              );
            },
            child: Text('Login'),
          )
        ],
      ),
    );
  }
}
