import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../widgets/expense_card.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'expenses_screen.dart';
import 'savings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    _HomeTab(),
    ExpensesScreen(),
    SavingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: const Color(0xFF2ECC71),
        unselectedItemColor: Colors.black26,
        selectedLabelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.savings_rounded), label: 'Savings'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  double _budget = 1500;
  double _spentWeek = 0;
  double _spentToday = 0;
  List<Expense> _recent = [];
  Map<String, dynamic> _savings = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _budget = StorageService.getWeeklyBudget();
      _spentWeek = StorageService.getTotalSpentThisWeek();
      _spentToday = StorageService.getTotalSpentToday();
      _recent = StorageService.getExpenses().take(3).toList();
      _savings = StorageService.getSavingsGoal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _budget - _spentWeek;
    final progress = _budget > 0 ? (_spentWeek / _budget).clamp(0.0, 1.0) : 0.0;
    final daysLeft = 7 - DateTime.now().weekday + 1;
    final isWarning = progress >= 0.8;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBudgetCard(remaining, progress, isWarning),
                const SizedBox(height: 24),
                _buildQuickStats(daysLeft),
                const SizedBox(height: 24),
                _buildSavingsGoal(),
                const SizedBox(height: 24),
                _buildRecentExpenses(),
              ],
            ),
          ),
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
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good day 👋',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black45)),
            Text('BudgetMo',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 26, fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A2E1A), letterSpacing: -0.5)),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF2ECC71).withOpacity(0.15),
          child: const Icon(Icons.person_rounded, color: Color(0xFF2ECC71)),
        ),
      ],
    );
  }

  Widget _buildBudgetCard(double remaining, double progress, bool isWarning) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isWarning
              ? [const Color(0xFF7D1F1F), const Color(0xFFB03A2E)]
              : [const Color(0xFF1A2E1A), const Color(0xFF2D5A2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isWarning ? const Color(0xFFE74C3C) : const Color(0xFF1A2E1A)).withOpacity(0.3),
            blurRadius: 20, offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Weekly Budget',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 13)),
              if (isWarning)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE74C3C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('⚠️ Almost full!',
                      style: GoogleFonts.plusJakartaSans(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text('₱${_budget.toStringAsFixed(2)}',
              style: GoogleFonts.plusJakartaSans(
                  color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white12,
              color: isWarning ? const Color(0xFFE74C3C) : const Color(0xFF2ECC71),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spent: ₱${_spentWeek.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 12)),
              Text('Left: ₱${remaining.toStringAsFixed(2)}',
                  style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF2ECC71), fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(int daysLeft) {
    return Row(
      children: [
        _statCard('Today', '₱${_spentToday.toStringAsFixed(0)}', Icons.today_rounded, const Color(0xFF3498DB)),
        const SizedBox(width: 12),
        _statCard('Saved', '₱${(_savings['saved'] ?? 0.0).toStringAsFixed(0)}', Icons.savings_rounded, const Color(0xFFF39C12)),
        const SizedBox(width: 12),
        _statCard('Days left', '$daysLeft', Icons.calendar_today_rounded, const Color(0xFFE74C3C)),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800, fontSize: 15, color: const Color(0xFF1A2E1A))),
            const SizedBox(height: 2),
            Text(label,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoal() {
    final saved = (_savings['saved'] ?? 0.0) as double;
    final target = (_savings['target'] ?? 3000.0) as double;
    final progress = target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🎯 Savings Goal',
                  style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700, fontSize: 15, color: const Color(0xFF1A2E1A))),
              Text('₱${saved.toStringAsFixed(0)} / ₱${target.toStringAsFixed(0)}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black45)),
            ],
          ),
          const SizedBox(height: 4),
          Text(_savings['name'] ?? 'My Goal',
              style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.black45)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.black,
              color: const Color(0xFFF39C12),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text('${(progress * 100).toStringAsFixed(1)}% achieved — keep going!',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12, color: const Color(0xFFF39C12), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Expenses',
                style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700, fontSize: 16, color: const Color(0xFF1A2E1A))),
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ExpensesScreen())),
              child: Text('See all',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: const Color(0xFF2ECC71), fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_recent.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text('No expenses yet — start logging!',
                  style: GoogleFonts.plusJakartaSans(color: Colors.black38)),
            ),
          )
        else
          ..._recent.map((e) => ExpenseCard(expense: e)),
      ],
    );
  }
}