import 'package:ecovery_test/model/expense.dart';
import 'package:ecovery_test/repository/expese_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc(this._repository) : super(const ExpenseState.initial()) {
    on<LoadExpenses>(_onLoad);
    on<AddExpense>(_onAdd);
    on<DeleteExpense>(_onDelete);
    on<SetCategoryFilter>(_onFilter);
    on<UpdateExpense>(_onUpdate);
  }

  final ExpenseRepository _repository;
  static const _uuid = Uuid();

  Future<void> _onLoad(
    LoadExpenses event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(state.copyWith(status: ExpenseStatus.loading));
    final items = await _repository.loadAll();
    emit(state.copyWith(status: ExpenseStatus.success, all: items));
  }

  Future<void> _onAdd(
    AddExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    final newItem = event.expense.id.isEmpty
        ? event.expense.copyWith(id: _uuid.v4())
        : event.expense;
    final updated = List<Expense>.from(state.all)..add(newItem);
    await _repository.saveAll(updated);
    emit(state.copyWith(all: updated));
  }

  Future<void> _onDelete(
    DeleteExpense event,
    Emitter<ExpenseState> emit,
  ) async {
    final updated = state.all.where((e) => e.id != event.id).toList();
    await _repository.saveAll(updated);
    emit(state.copyWith(all: updated));
  }

  void _onFilter(
    SetCategoryFilter event,
    Emitter<ExpenseState> emit,
  ) {
    emit(state.copyWith(activeFilter: event.category));
  }

  Future<void> _onUpdate(
      UpdateExpense event, Emitter<ExpenseState> emit) async {
    final updated = state.all
        .map((e) => e.id == event.expense.id ? event.expense : e)
        .toList();
    await _repository.saveAll(updated);
    emit(state.copyWith(all: updated));
  }
}
