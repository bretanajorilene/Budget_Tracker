import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';

class StorageService {
  static const String _expenseBox = 'expenses';
  static const String _budgetBox = 'budget';
  static const String _savingsBox = 'savings';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(_expenseBox);
    await Hive.openBox(_budgetBox);
    await Hive.openBox(_savingsBox);
  }

  // EXPENSES
  static List<Expense> getExpenses() {
    final box = Hive.box(_expenseBox);
    return box.values
        .map((e) => Expense.fromMap(Map<String, dynamic>.from(e)))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> addExpense(Expense expense) async {
    final box = Hive.box(_expenseBox);
    await box.add(expense.toMap());
  }

  static Future<void> deleteExpense(int index) async {
    final box = Hive.box(_expenseBox);
    final keys = box.keys.toList();
    await box.delete(keys[index]);
  }

  // BUDGET
  static double getWeeklyBudget() {
    final box = Hive.box(_budgetBox);
    return box.get('weekly', defaultValue: 1500.0);
  }

  static Future<void> setWeeklyBudget(double amount) async {
    final box = Hive.box(_budgetBox);
    await box.put('weekly', amount);
  }

  // SAVINGS
  static Map<String, dynamic> getSavingsGoal() {
    final box = Hive.box(_savingsBox);
    return {
      'name': box.get('name', defaultValue: 'My Goal'),
      'target': box.get('target', defaultValue: 3000.0),
      'saved': box.get('saved', defaultValue: 0.0),
    };
  }

  static Future<void> setSavingsGoal(String name, double target) async {
    final box = Hive.box(_savingsBox);
    await box.put('name', name);
    await box.put('target', target);
  }

  static Future<void> addToSavings(double amount) async {
    final box = Hive.box(_savingsBox);
    final current = box.get('saved', defaultValue: 0.0);
    await box.put('saved', current + amount);
  }

  // HELPERS
  static double getTotalSpentThisWeek() {
    final expenses = getExpenses();
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final weekStart = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    return expenses
        .where((e) => !e.date.isBefore(weekStart))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  static double getTotalSpentToday() {
    final expenses = getExpenses();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return expenses
        .where((e) => DateTime(e.date.year, e.date.month, e.date.day) == today)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}