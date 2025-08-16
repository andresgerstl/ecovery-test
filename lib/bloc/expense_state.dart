part of 'expense_bloc.dart';

enum ExpenseStatus { initial, loading, success, failure }

class ExpenseState extends Equatable {
  final ExpenseStatus status;
  final List<Expense> all;
  final ExpenseCategory? activeFilter;

  const ExpenseState({
    required this.status,
    required this.all,
    required this.activeFilter,
  });

  const ExpenseState.initial()
      : status = ExpenseStatus.initial,
        all = const [],
        activeFilter = null;

  List<Expense> get visible {
    if (activeFilter == null) return all;
    return all.where((e) => e.category == activeFilter).toList();
  }

  double get total {
    return all.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  ExpenseState copyWith({
    ExpenseStatus? status,
    List<Expense>? all,
    ExpenseCategory? activeFilter,
  }) {
    return ExpenseState(
      status: status ?? this.status,
      all: all ?? this.all,
      activeFilter: activeFilter,
    );
  }

  @override
  List<Object?> get props => [status, all, activeFilter];
}
