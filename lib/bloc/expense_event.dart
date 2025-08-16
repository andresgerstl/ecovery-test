part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  const LoadExpenses();
}

class AddExpense extends ExpenseEvent {
  final Expense expense;
  const AddExpense(this.expense);
  @override
  List<Object?> get props => [expense];
}

class DeleteExpense extends ExpenseEvent {
  final String id;
  const DeleteExpense(this.id);
  @override
  List<Object?> get props => [id];
}

class SetCategoryFilter extends ExpenseEvent {
  final ExpenseCategory? category;
  const SetCategoryFilter(this.category);
  @override
  List<Object?> get props => [category];
}

class UpdateExpense extends ExpenseEvent {
  const UpdateExpense(this.expense);
  final Expense expense;

  @override
  List<Object?> get props => [expense];
}
