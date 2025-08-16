import 'package:bloc_test/bloc_test.dart';
import 'package:ecovery_test/bloc/expense_bloc.dart';
import 'package:ecovery_test/model/expense.dart';
import 'package:ecovery_test/repository/expese_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements ExpenseRepository {
  List<Expense> _store = [];
  @override
  Future<List<Expense>> loadAll() async => _store;

  @override
  Future<void> saveAll(List<Expense> expenses) async {
    _store = List.of(expenses);
  }
}

void main() {
  group('ExpensesBloc', () {
    late _FakeRepo repo;
    setUp(() {
      repo = _FakeRepo();
    });

    blocTest<ExpenseBloc, ExpenseState>(
      'loads empty list',
      build: () => ExpenseBloc(repo),
      act: (b) => b.add(const LoadExpenses()),
      expect: () => [
        const ExpenseState(
            status: ExpenseStatus.loading, all: [], activeFilter: null),
        const ExpenseState(
            status: ExpenseStatus.success, all: [], activeFilter: null),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'adds and deletes expense',
      build: () => ExpenseBloc(repo),
      act: (b) async {
        b.add(const LoadExpenses());
        await Future<void>.delayed(const Duration(milliseconds: 1));
        b.add(AddExpense(Expense(
          id: '',
          amount: 10.0,
          category: ExpenseCategory.food,
          description: 'Lunch',
          date: DateTime(2024, 1, 1),
        )));
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final added = b.state.all.first;
        b.add(DeleteExpense(added.id));
      },
      skip:
          2, // skip: 1 (loading state after LoadExpenses), 2 (success state after loading empty list)
      expect: () => [
        isA<ExpenseState>().having((s) => s.all.length, 'length after add', 1),
        isA<ExpenseState>()
            .having((s) => s.all.length, 'length after delete', 0),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'filters by category',
      build: () => ExpenseBloc(repo),
      act: (b) async {
        b.add(const LoadExpenses());
        await Future<void>.delayed(const Duration(milliseconds: 1));
        await repo.saveAll([
          Expense(
              id: '1',
              amount: 5,
              category: ExpenseCategory.food,
              description: 'a',
              date: DateTime(2024)),
          Expense(
              id: '2',
              amount: 7,
              category: ExpenseCategory.transport,
              description: 'b',
              date: DateTime(2024)),
        ]);
        b.add(const LoadExpenses());
        await Future<void>.delayed(const Duration(milliseconds: 1));
        b.add(const SetCategoryFilter(ExpenseCategory.food));
      },
      skip:
          3, // skip: 1 (loading state after first LoadExpenses), 2 (success state after loading expenses), 3 (success state after loading expenses again)
      expect: () => [
        isA<ExpenseState>().having((s) => s.all.length, 'loaded all', 2),
        isA<ExpenseState>()
            .having((s) => s.activeFilter, 'filter set', ExpenseCategory.food)
            .having((s) => s.visible.length, 'filtered visible', 1),
      ],
    );

    blocTest<ExpenseBloc, ExpenseState>(
      'updates an expense',
      build: () => ExpenseBloc(repo),
      act: (b) async {
        b.add(const LoadExpenses());
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final expense = Expense(
          id: '1',
          amount: 5,
          category: ExpenseCategory.food,
          description: 'a',
          date: DateTime(2024),
        );
        await repo.saveAll([expense]);
        b.add(const LoadExpenses());
        await Future<void>.delayed(const Duration(milliseconds: 1));
        final updated = expense.copyWith(
          amount: 10,
          description: 'updated',
        );
        b.add(UpdateExpense(updated));
      },
      skip:
          4, // skip: 1 (loading), 2 (success after loading), 3 (success after loading again), 4 (success after update with old expense)
      expect: () => [
        isA<ExpenseState>()
            .having((s) => s.all.first.amount, 'updated amount', 10)
            .having((s) => s.all.first.description, 'updated description',
                'updated'),
      ],
    );
  });
}
