import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  Map<String, dynamic> _goal = {};
  final _nameCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  final _addCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _goal = StorageService.getSavingsGoal();
      _nameCtrl.text = _goal['name'];
      _targetCtrl.text = _goal['target'].toString();
    });
  }

  void _saveGoal() async {
    final target = double.tryParse(_targetCtrl.text);
    if (_nameCtrl.text.isEmpty || target == null) return;
    await StorageService.setSavingsGoal(_nameCtrl.text.trim(), target);
    _load();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Goal updated!')),
    );
  }

  void _addSavings() async {
    final amount = double.tryParse(_addCtrl.text);
    if (amount == null || amount <= 0) return;
    await StorageService.addToSavings(amount);
    _addCtrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final saved = (_goal['saved'] ?? 0.0) as double;
    final target = (_goal['target'] ?? 3000.0) as double;
    final progress = target > 0 ? (saved / target).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7F5),
        elevation: 0,
        title: Text('Savings Goal',
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700, fontSize: 20, color: const Color(0xFF1A2E1A))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Goal progress card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A2E1A), Color(0xFF2D5A2D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🎯 ${_goal['name'] ?? 'My Goal'}',
                      style: GoogleFonts.plusJakartaSans(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₱${saved.toStringAsFixed(2)} saved',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white60, fontSize: 13)),
                      Text('₱${target.toStringAsFixed(2)} goal',
                          style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF2ECC71), fontSize: 13, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white12,
                      color: const Color(0xFF2ECC71),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('$percent% achieved',
                      style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF2ECC71), fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Add to savings
            _sectionCard('Add to Savings', [
              _inputRow('Amount (₱)', _addCtrl, isNumber: true),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addSavings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2ECC71),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Add', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // Edit goal
            _sectionCard('Edit Goal', [
              _inputRow('Goal Name', _nameCtrl),
              const SizedBox(height: 12),
              _inputRow('Target Amount (₱)', _targetCtrl, isNumber: true),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _saveGoal,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2ECC71)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Update Goal',
                      style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700, color: const Color(0xFF2ECC71))),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700, fontSize: 15, color: const Color(0xFF1A2E1A))),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _inputRow(String label, TextEditingController ctrl, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.black45)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: GoogleFonts.plusJakartaSans(fontSize: 14),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}