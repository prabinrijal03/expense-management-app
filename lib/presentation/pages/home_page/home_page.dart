import 'package:flutter/material.dart';

import '../../../domain/entities/user.dart';
import 'admin_dashboard.dart';
import 'employee_dashboard.dart';
import 'manager_dashboard.dart';

class HomePage extends StatelessWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.role} Dashboard'),
        actions: [/* Logout button */],
      ),
      body: _buildRoleSpecificUI(),
    );
  }

  Widget _buildRoleSpecificUI() {
    switch (user.role) {
      case 'admin':
        return const AdminDashboard();
      case 'manager':
        return const ManagerDashboard();
      default:
        return const EmployeeDashboard();
    }
  }
}
