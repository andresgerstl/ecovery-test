import 'package:ecovery_test/bloc/expense_bloc.dart';
import 'package:ecovery_test/repository/expese_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = await SharedPrefsExpenseRepository.create();
  runApp(RepositoryProvider<ExpenseRepository>.value(
    value: repo,
    child: BlocProvider(
      create: (_) => ExpenseBloc(repo)..add(const LoadExpenses()),
      child: const ExpenseApp(),
    ),
  ));
}
