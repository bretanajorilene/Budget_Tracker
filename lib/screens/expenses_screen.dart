import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expense.dart';
import '../services/storage_service.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() => setState(() => _expenses = StorageService.getExpenses());

  void _delete(int index) async {
    await StorageService.deleteExpense(index);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F5),
        elevation: 0,
        title: Text('All Expenses',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700, fontSize: 20, color: const Color(0xFF1A2E1A))),
      ),
      body: _expenses.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💸', style: TextStyle(fontSize: 50)),
            const SizedBox(height: 12),
            Text('No expenses yet',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 16, color: Colors.black38, fontWeight: FontWeight.w500)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _expenses.length,
        itemBuilder: (context, index) => ExpenseCard(
          expense: _expenses[index],
          onDelete: () => _delete(index),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
          if (result == true) _load();
        },
        backgroundColor: const Color(0xFF2ECC71),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}