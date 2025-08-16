import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

@freezed
class Expense with _$Expense {
  const factory Expense({
    required String id,
    required double amount,
    required ExpenseCategory category,
    required String description,
    required DateTime date,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);
}

@JsonEnum()
enum ExpenseCategory {
  food,
  transport,
  housing,
  entertainment,
  utilities,
  health,
  other
}
