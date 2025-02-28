import 'package:expense_management_app/core/dependency_injection/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import 'admin_dashboard.dart';
import 'employee_dashboard.dart';
import 'manager_dashboard.dart';

class HomePage extends StatelessWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${user.role} Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthEvent.signOut()),
            ),
          ],
        ),
        body: _buildRoleSpecificUI(),
      ),
    );
  }

  Widget _buildRoleSpecificUI() {
    switch (user.role.toLowerCase()) {
      case 'admin':
        return const AdminDashboard();
      case 'manager':
        return const ManagerDashboard();
      default:
        return EmployeeDashboard(user: user);
    }
  }
}
