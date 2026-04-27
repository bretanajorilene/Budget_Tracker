import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onDelete;

  const ExpenseCard({super.key, required this.expense, this.onDelete});

  static const Map<String, Map<String, dynamic>> categoryData = {
    'Food':          {'icon': '🍱', 'color': Color(0xFF2ECC71)},
    'Transport':     {'icon': '🚌', 'color': Color(0xFF3498DB)},
    'Supplies':      {'icon': '📓', 'color': Color(0xFFF39C12)},
    'Entertainment': {'icon': '🎮', 'color': Color(0xFF9B59B6)},
    'Health':        {'icon': '💊', 'color': Color(0xFFE74C3C)},
    'Other':         {'icon': '📦', 'color': Color(0xFF95A5A6)},
  };

  @override
  Widget build(BuildContext context) {
    final cat = categoryData[expense.category] ?? categoryData['Other']!;
    final color = cat['color'] as Color;
    final icon = cat['icon'] as String;

    return Dismissible(
      key: Key(expense.date.toString() + expense.title),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE74C3C),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      child: Container(
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(expense.title,
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF1A2E1A))),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(expense.category,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Text(
              '₱${expense.amount.toStringAsFixed(2)}',
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700, fontSize: 15, color: const Color(0xFFE74C3C)),
            ),
          ],
        ),
      ),
    );
  }
}