import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/expense_entity.dart';
import '../../bloc/bloc/expense_bloc.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return StreamBuilder<List<ExpenseEntity>>(
          stream: context.read<ExpenseBloc>().expenseStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();
            
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final expense = snapshot.data![index];
                return ListTile(
                  title: Text(expense.title),
                  subtitle: Text(expense.status),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () => context.read<ExpenseBloc>().add(
                          ExpenseEvent.updateStatus(
                            expenseId: expense.id,
                            status: 'approved'
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.read<ExpenseBloc>().add(
                          ExpenseEvent.updateStatus(
                            expenseId: expense.id,
                            status: 'rejected'
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}