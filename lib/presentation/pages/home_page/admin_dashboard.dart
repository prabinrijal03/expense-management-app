import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/expense_bloc.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildSummaryCards(context),
            Expanded(child: _buildExpenseChart(context)),
            Expanded(child: _buildExpenseList(context)),
          ],
        );
      },
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    return ListView.builder(
      itemCount: context.read<ExpenseBloc>().expenseData.length,
      itemBuilder: (context, index) {
        final expense = context.read<ExpenseBloc>().expenseData[index];
        return ListTile(
          title: Text(expense.title),
          subtitle: Text(expense.status),
          trailing: Text('\$${expense.amount.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

Widget _buildSummaryCards(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildCard('Total Expenses', '1000'),
      _buildCard('Approved', '800'),
      _buildCard('Pending', '150'),
      _buildCard('Rejected', '50'),
    ],
  );
}

Widget _buildCard(String title, String amount) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),
          Text(amount, style: TextStyle(fontSize: 24)),
        ],
      ),
    ),
  );
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'approved':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

Widget _buildExpenseChart(BuildContext context) {
  return BarChart(
    BarChartData(
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: false),
      barGroups: context
          .read<ExpenseBloc>()
          .expenseData
          .map((e) => BarChartGroupData(x: int.parse(e.id), barRods: [
                BarChartRodData(toY: e.amount, color: _getStatusColor(e.status))
              ]))
          .toList(),
    ),
  );
}
