import 'dart:convert';

import 'package:ecovery_test/model/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ExpenseRepository {
  Future<List<Expense>> loadAll();
  Future<void> saveAll(List<Expense> expenses);
}

class SharedPrefsExpenseRepository implements ExpenseRepository {
  static const _key = 'expenses_v1';
  final SharedPreferences _prefs;

  SharedPrefsExpenseRepository._(this._prefs);

  static Future<SharedPrefsExpenseRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPrefsExpenseRepository._(prefs);
  }

  @override
  Future<List<Expense>> loadAll() async {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <Expense>[];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> saveAll(List<Expense> expenses) async {
    final encoded = jsonEncode(expenses.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
