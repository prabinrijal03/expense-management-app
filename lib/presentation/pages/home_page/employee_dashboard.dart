import 'dart:io';
import 'dart:typed_data';

import 'package:expense_management_app/core/dependency_injection/dependency_injection.dart';
import 'package:expense_management_app/domain/entities/expense_entity.dart';
import 'package:expense_management_app/presentation/bloc/bloc/expense_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/user.dart';

class EmployeeDashboard extends StatelessWidget {
  final UserEntity user;
  Uint8List? receiptImage;
  EmployeeDashboard({super.key, required this.user});
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExpenseBloc>(),
      child: Scaffold(
        body: BlocConsumer<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            state.whenOrNull(
              submitting: () => showDialog(
                context: context,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              submitSuccess: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense added')),
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
            return Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final file = await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    if (file != null) {
                      receiptImage = file.files.first.bytes;
                    }
                  },
                  child: const Text('Upload Receipt'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      return;
                    }
                    context.read<ExpenseBloc>().add(
                          ExpenseEvent.submit(
                            expense: ExpenseEntity(
                              id: '',
                              userId: user.uid,
                              title: titleController.text,
                              description: descriptionController.text,
                              amount: double.parse(amountController.text),
                              receiptUrl: '',
                              timestamp: DateTime.now(),
                              status: 'pending',
                            ),
                            receipt: receiptImage!,
                          ),
                        );
                  },
                  child: const Text('Add Expense'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
