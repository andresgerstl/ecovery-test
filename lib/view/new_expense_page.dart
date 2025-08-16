import 'package:ecovery_test/bloc/expense_bloc.dart';
import 'package:ecovery_test/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key, this.initial});
  final Expense? initial; // null => create, non-null => edit

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _descriptionCtrl;
  late DateTime _date;
  late ExpenseCategory _category;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final e = widget.initial;
    _amountCtrl = TextEditingController(
      text: e != null ? e.amount.toStringAsFixed(2) : '',
    );
    _descriptionCtrl = TextEditingController(text: e?.description ?? '');
    _date = e?.date ?? DateTime.now();
    _category = e?.category ?? ExpenseCategory.other;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat.yMMMd();
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit expense' : 'New expense'),
        actions: [
          if (_isEdit)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context
                    .read<ExpenseBloc>()
                    .add(DeleteExpense(widget.initial!.id));
                context.pop();
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter amount';
                  final parsed = double.tryParse(v.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExpenseCategory>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ExpenseCategory.values
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(_labelFor(e))))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLength: 80,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter description';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(dateFmt.format(_date)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(now.year - 5),
                        lastDate: DateTime(now.year + 5),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: const Text('Pick'),
                  )
                ],
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(_isEdit ? 'Save changes' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountCtrl.text.replaceAll(',', '.'));
    final desc = _descriptionCtrl.text.trim();

    if (_isEdit) {
      final updated = widget.initial!.copyWith(
        amount: amount,
        category: _category,
        description: desc,
        date: _date,
      );
      context.read<ExpenseBloc>().add(UpdateExpense(updated));
    } else {
      final expense = Expense(
        id: const Uuid().v4(),
        amount: amount,
        category: _category,
        description: desc,
        date: _date,
      );
      context.read<ExpenseBloc>().add(AddExpense(expense));
    }
    context.pop();
  }

  static String _labelFor(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.transport:
        return 'Transport';
      case ExpenseCategory.housing:
        return 'Housing';
      case ExpenseCategory.entertainment:
        return 'Entertainment';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.health:
        return 'Health';
      case ExpenseCategory.other:
        return 'Other';
    }
  }
}
