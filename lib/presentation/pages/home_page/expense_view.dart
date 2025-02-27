/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bloc/expense_bloc.dart';

class ExpenseListView extends StatefulWidget {
  @override
  _ExpenseListViewState createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<ExpenseListView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == 
        _scrollController.position.maxScrollExtent) {
      context.read<ExpenseBloc>().add(ExpenseEvent.fetch(userId: null, status: _selectedFilter));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchBar(controller: _searchController),
        DropdownButton(
          value: _selectedFilter,
          items: /* ... filter items ... */,
          onChanged: (value) => setState(() => _selectedFilter = value!),
        ),
        Expanded(
          child: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.expenses.length + (state.hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.expenses.length) {
                    return const LoadingIndicator();
                  }
                  return ExpenseListItem(expense: state.expenses[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
} */