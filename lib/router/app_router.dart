import 'package:ecovery_test/bloc/expense_bloc.dart';
import 'package:ecovery_test/view/expense_page.dart';
import 'package:ecovery_test/view/new_expense_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: AppRoutes.home,
      path: AppPaths.home,
      builder: (context, state) => const ExpensesPage(),
      routes: [
        GoRoute(
          name: AppRoutes.expenseNew,
          path: 'expense/new',
          builder: (context, state) => const NewExpensePage(),
        ),
        GoRoute(
          name: AppRoutes.expenseEdit,
          path: 'expense/:id/edit',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final bloc = context.read<ExpenseBloc>();
            final expense = bloc.state.all.firstWhere((e) => e.id == id);
            return NewExpensePage(initial: expense);
          },
        ),
      ],
    ),
  ],
);
