import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';
import '../../models/journal_entry.dart';

class NourishScreen extends StatefulWidget {
  const NourishScreen({super.key});
  @override
  State<NourishScreen> createState() => _NourishScreenState();
}

class _NourishScreenState extends State<NourishScreen> {
  final _storage = StorageService();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMealType = 'meal';
  int _satisfaction = 3;
  List<MealLog> _logs = [];
  int _waterCups = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final user = _storage.loadUserData();
    _waterCups = user.waterCups;
    _storage.getMealLogs(limit: 20).then((logs) {
      setState(() => _logs = logs);
    });
  }

  void _saveMeal() async {
    if (_descController.text.trim().isEmpty) return;
    final meal = MealLog(
      date: DateTime.now(),
      mealType: _selectedMealType,
      description: _descController.text.trim(),
      satisfaction: _satisfaction,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );
    await _storage.saveMealLog(meal);
    final user = _storage.loadUserData();
    user.nourishmentCount++;
    await _storage.saveUserData(user);
    await _storage.saveDailyLog(
      date: DateTime.now().toIso8601String().split('T')[0],
      nourishmentCount: user.nourishmentCount,
    );
    _descController.clear();
    _notesController.clear();
    setState(() => _satisfaction = 3);
    _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Nourishment logged! 🌿'),
          backgroundColor: AppTheme.softMint, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _updateWater(int delta) async {
    setState(() => _waterCups = (_waterCups + delta).clamp(0, 8));
    final user = _storage.loadUserData();
    user.waterCups = _waterCups;
    await _storage.saveUserData(user);
    await _storage.saveDailyLog(
      date: DateTime.now().toIso8601String().split('T')[0],
      waterCups: user.waterCups,
    );
  }

  @override
  void dispose() {
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      appBar: AppBar(
        title: const Text('Nourish', style: TextStyle(color: AppTheme.softSand)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(today, style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.6))),
            const SizedBox(height: 4),
            const Text('Mindful Nourishment', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.softSand)),
            const SizedBox(height: 8),
            Text('No judgment, no diet rules — just noticing what you eat and how it makes you feel.',
                style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.6))),
            const SizedBox(height: 20),

            // Water tracker inline
            GlassCard(
              padding: const EdgeInsets.all(14),
              opacity: 0.08,
              radius: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text('💧', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 8),
                      Text('Water', style: TextStyle(fontSize: 15, color: AppTheme.softSand)),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.white54, size: 20),
                        onPressed: _waterCups > 0 ? () => _updateWater(-1) : null,
                      ),
                      Text('$_waterCups/8', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.warmCoral)),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: AppTheme.warmCoral, size: 20),
                        onPressed: _waterCups < 8 ? () => _updateWater(1) : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Log a meal
            const Text('Log Your Meal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
            const SizedBox(height: 12),
            GlassCard(
              padding: const EdgeInsets.all(16),
              opacity: 0.08,
              radius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal type selector
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _mealTypeChip('Breakfast', 'breakfast'),
                        const SizedBox(width: 8),
                        _mealTypeChip('Lunch', 'lunch'),
                        const SizedBox(width: 8),
                        _mealTypeChip('Dinner', 'dinner'),
                        const SizedBox(width: 8),
                        _mealTypeChip('Snack', 'snack'),
                        const SizedBox(width: 8),
                        _mealTypeChip('Meal', 'meal'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(
                      hintText: 'What did you eat? (e.g., "Oatmeal with berries")',
                      hintStyle: TextStyle(color: Color(0x66FFFFFF), fontSize: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    style: const TextStyle(color: AppTheme.softSand, fontSize: 14),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  // Satisfaction
                  const Text('How satisfying was that?', style: TextStyle(fontSize: 13, color: AppTheme.softSand)),
                  const SizedBox(height: 6),
                  Row(
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _satisfaction = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            i < _satisfaction ? Icons.star : Icons.star_border,
                            color: i < _satisfaction ? AppTheme.warmAmber : Colors.white30,
                            size: 30,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'Notes (taste, texture, how you felt...)',
                      hintStyle: TextStyle(color: Color(0x66FFFFFF), fontSize: 13),
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    style: const TextStyle(color: AppTheme.softSand, fontSize: 13),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveMeal,
                      child: const Text('Log Meal'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent logs
            const Text('Recent Meals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
            const SizedBox(height: 12),
            if (_logs.isEmpty)
              GlassCard(
                opacity: 0.06,
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_outlined, size: 40, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(height: 8),
                      Text('No meals logged yet.\nStart by logging what you ate!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.5))),
                    ],
                  ),
                ),
              )
            else
              ..._logs.take(5).map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(12),
                  radius: 14,
                  opacity: 0.06,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.warmCoral.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(log.mealType.toUpperCase(),
                            style: const TextStyle(fontSize: 10, color: AppTheme.warmCoral, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(log.description,
                                style: const TextStyle(fontSize: 14, color: AppTheme.softSand)),
                            Text(log.formattedTime,
                                style: TextStyle(fontSize: 11, color: AppTheme.softSand.withValues(alpha: 0.5))),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(log.satisfaction, (i) =>
                          const Icon(Icons.star, color: AppTheme.warmAmber, size: 14)),
                      ),
                    ],
                  ),
                ),
              )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _mealTypeChip(String label, String value) {
    final isSelected = _selectedMealType == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMealType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.warmCoral.withValues(alpha: 0.2) : AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.warmCoral : AppTheme.glassBorder),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13,
              color: isSelected ? AppTheme.warmCoral : Colors.white70,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            )),
      ),
    );
  }
}
