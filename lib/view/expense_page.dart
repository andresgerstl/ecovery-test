import 'package:ecovery_test/bloc/expense_bloc.dart';
import 'package:ecovery_test/model/expense.dart';
import 'package:ecovery_test/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: const [_CategoryFilterButton()],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state.status == ExpenseStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.visible.isEmpty) {
            return const _EmptyState();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(currency.format(state.total),
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: ListView.separated(
                  itemCount: state.visible.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final e = state.visible[index];
                    return Dismissible(
                      key: ValueKey(e.id),
                      background: Container(color: Colors.redAccent),
                      onDismissed: (_) {
                        context.read<ExpenseBloc>().add(DeleteExpense(e.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Expense deleted')),
                        );
                      },
                      child: ListTile(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.expenseEdit,
                            pathParameters: {'id': e.id},
                          );
                        },
                        title: Text(e.description),
                        subtitle: Text(DateFormat.yMMMd().format(e.date)),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(currency.format(e.amount)),
                            Text(_labelFor(e.category),
                                style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.pushNamed(AppRoutes.expenseNew);
        },
        icon: const Icon(Icons.add),
        label: const Text('Add expense'),
      ),
    );
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.receipt_long, size: 64),
          const SizedBox(height: 12),
          Text('No expenses yet',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Tap the + button to add your first one',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _CategoryFilterButton extends StatelessWidget {
  const _CategoryFilterButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      buildWhen: (p, n) => p.activeFilter != n.activeFilter,
      builder: (context, state) {
        final current = state.activeFilter;

        return DropdownButtonHideUnderline(
          child: DropdownButton<ExpenseCategory?>(
            value: current,
            hint: const Text('All categories'),
            onChanged: (value) {
              context.read<ExpenseBloc>().add(SetCategoryFilter(value));
            },
            items: <DropdownMenuItem<ExpenseCategory?>>[
              const DropdownMenuItem(
                value: null,
                child: Text('All categories'),
              ),
              ...ExpenseCategory.values.map(
                (category) => DropdownMenuItem<ExpenseCategory?>(
                  value: category,
                  child: Text(_label(category)),
                ),
              ),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        );
      },
    );
  }

  static String _label(ExpenseCategory c) {
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
