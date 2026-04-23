import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 24),

              // Budget card
              _buildBudgetCard(),
              const SizedBox(height: 24),

              // Quick stats row
              _buildQuickStats(),
              const SizedBox(height: 24),

              // Savings goal
              _buildSavingsGoal(),
              const SizedBox(height: 24),

              // Recent expenses placeholder
              _buildRecentExpenses(),
            ],
          ),
        ),
      ),

      // Bottom nav bar
      bottomNavigationBar: _buildBottomNav(),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2ECC71),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning 👋',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Juan dela Cruz',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A2E1A),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFF2ECC71).withOpacity(0.15),
          child: const Icon(
            Icons.person_rounded,
            color: Color(0xFF2ECC71),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2E1A), Color(0xFF2D5A2D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A2E1A).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Budget',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₱ 1,500.00',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.45,
              backgroundColor: Colors.white12,
              color: const Color(0xFF2ECC71),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ₱675.00',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
              Text(
                'Left: ₱825.00',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF2ECC71),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _statCard('Today', '₱120', Icons.today_rounded, const Color(0xFF3498DB)),
        const SizedBox(width: 12),
        _statCard('Saved', '₱200', Icons.savings_rounded, const Color(0xFFF39C12)),
        const SizedBox(width: 12),
        _statCard('Days left', '4', Icons.calendar_today_rounded, const Color(0xFFE74C3C)),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: const Color(0xFF1A2E1A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingsGoal() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🎯 Savings Goal',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: const Color(0xFF1A2E1A),
                ),
              ),
              Text(
                '₱800 / ₱3,000',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'New Earphones',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 800 / 3000,
              backgroundColor: Colors.black,
              color: const Color(0xFFF39C12),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '27% achieved — keep going!',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFFF39C12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses() {
    final expenses = [
      {'label': 'Lunch', 'cat': 'Food', 'amount': '-₱65', 'icon': '🍱', 'color': const Color(0xFF2ECC71)},
      {'label': 'Jeep fare', 'cat': 'Transport', 'amount': '-₱14', 'icon': '🚌', 'color': const Color(0xFF3498DB)},
      {'label': 'Notebook', 'cat': 'Supplies', 'amount': '-₱45', 'icon': '📓', 'color': const Color(0xFFF39C12)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Expenses',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: const Color(0xFF1A2E1A),
              ),
            ),
            Text(
              'See all',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF2ECC71),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...expenses.map((e) => _expenseItem(e)),
      ],
    );
  }

  Widget _expenseItem(Map<String, dynamic> e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(e['icon'] as String, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e['label'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xFF1A2E1A),
                  ),
                ),
                Text(
                  e['cat'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          ),
          Text(
            e['amount'] as String,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: const Color(0xFFE74C3C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      elevation: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_rounded, 'Home', true),
          _navItem(Icons.bar_chart_rounded, 'Charts', false),
          const SizedBox(width: 40), // FAB space
          _navItem(Icons.list_alt_rounded, 'Expenses', false),
          _navItem(Icons.settings_rounded, 'Settings', false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool active) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? const Color(0xFF2ECC71) : Colors.black26,
          size: 26,
        ),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: active ? const Color(0xFF2ECC71) : Colors.black26,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}