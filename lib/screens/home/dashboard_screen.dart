import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';
import '../../models/user_data.dart';
import '../../screens/journal/journal_screen.dart';
import '../../screens/sos/sos_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _storage = StorageService();
  UserData _user = UserData();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() => _user = _storage.loadUserData());
  }

  Future<void> _updateWater(int delta) async {
    _user.waterCups = (_user.waterCups + delta).clamp(0, 8);
    await _storage.saveUserData(_user);
    await _storage.saveDailyLog(
      date: DateTime.now().toIso8601String().split('T')[0],
      waterCups: _user.waterCups,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello${_user.name.isNotEmpty ? ', ${_user.name}' : ''}!',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      _getTimeGreeting(),
                      style: const TextStyle(color: AppTheme.textSecondary),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.warmCoral.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.local_fire_department, color: AppTheme.warmCoral, size: 20),
                      Text('${_user.streak}', style: const TextStyle(color: AppTheme.warmCoral, fontSize: 12, fontWeight: FontWeight.bold)),
                      const Text('day', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mood Check-in
            GlassCard(
              padding: const EdgeInsets.all(16),
              opacity: 0.06,
              borderColor: AppTheme.primaryPurple.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.emoji_emotions_outlined, color: AppTheme.warmGold, size: 18),
                      SizedBox(width: 8),
                      Text('How are you feeling?', style: TextStyle(fontSize: 14, color: AppTheme.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _moodButton('great', '😊'),
                      _moodButton('good', '🙂'),
                      _moodButton('okay', '😐'),
                      _moodButton('low', '😔'),
                      _moodButton('rough', '😢'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Affirmation
            GlassCard(
              opacity: 0.1,
              borderColor: AppTheme.warmGold.withValues(alpha: 0.2),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.warmGold.withValues(alpha: 0.2), AppTheme.warmGold.withValues(alpha: 0.05)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppTheme.warmGold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getDailyAffirmation(),
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Wellness Pillars
            const Text('Your Wellness', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _pillarCard('Nourish', Icons.restaurant_rounded, _user.nourishmentCount, 5, AppTheme.vibrantGreen)),
                const SizedBox(width: 8),
                Expanded(child: _pillarCard('Rest', Icons.nightlight_round, _user.sleepHours.clamp(0, 8), 8, AppTheme.cyanTeal)),
                const SizedBox(width: 8),
                Expanded(child: _pillarCard('Move', Icons.directions_run_rounded, _user.movementMinutes.clamp(0, 30), 30, AppTheme.warmCoral, suffix: 'min')),
              ],
            ),
            const SizedBox(height: 16),

            // Water Tracker
            GlassCard(
              padding: const EdgeInsets.all(16),
              opacity: 0.06,
              borderColor: AppTheme.cyanTeal.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.water_drop, color: AppTheme.cyanTeal, size: 18),
                          SizedBox(width: 8),
                          Text('Water Intake', style: TextStyle(fontSize: 15, color: AppTheme.textPrimary)),
                        ],
                      ),
                      Text('${_user.waterCups}/8 cups',
                          style: const TextStyle(color: AppTheme.cyanTeal, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppTheme.textMuted),
                          onPressed: _user.waterCups > 0 ? () => _updateWater(-1) : null,
                        ),
                        ...List.generate(8, (i) {
                          final filled = i < _user.waterCups;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              width: 24, height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: filled ? AppTheme.cyanTeal : Colors.white.withValues(alpha: 0.1),
                                border: filled ? null : Border.all(color: Colors.white.withValues(alpha: 0.2)),
                                boxShadow: filled ? [BoxShadow(color: AppTheme.cyanTeal.withValues(alpha: 0.4), blurRadius: 8)] : null,
                              ),
                              child: filled
                                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                                  : null,
                            ),
                          );
                        }),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: AppTheme.cyanTeal),
                          onPressed: _user.waterCups < 8 ? () => _updateWater(1) : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Actions
            Row(
              children: [
                Expanded(child: _quickAction('Journal', Icons.edit_note_rounded, AppTheme.vibrantGreen, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen()));
                })),
                const SizedBox(width: 8),
                Expanded(child: _quickAction('SOS', Icons.healing_rounded, AppTheme.warmCoral, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSScreen()));
                })),
                const SizedBox(width: 8),
                Expanded(child: _quickAction('Coach', Icons.smart_toy_rounded, AppTheme.primaryPurple, () {
                  // Switch to coach tab - but we're in a pushed route,
                  // so pop back and switch tab
                  Navigator.popUntil(context, (route) => route.isFirst);
                })),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }

  String _getDailyAffirmation() {
    if (_user.customAffirmation != null && _user.customAffirmation!.isNotEmpty) {
      return _user.customAffirmation!;
    }
    final affirmations = [
      'You are enough, exactly as you are.',
      'Every small step counts. You\'re moving forward.',
      'Your body is your ally, not your enemy.',
      'Progress over perfection — always.',
      'You deserve kindness, especially from yourself.',
      'Today is a fresh start. You\'ve got this.',
      'Be proud of yourself for showing up today.',
    ];
    return affirmations[DateTime.now().day % affirmations.length];
  }

  Widget _moodButton(String mood, String emoji) {
    final isSelected = _user.moodToday == mood;
    return GestureDetector(
      onTap: () async {
        _user.moodToday = mood;
        await _storage.saveUserData(_user);
        await _storage.saveDailyLog(
          date: DateTime.now().toIso8601String().split('T')[0],
          mood: mood,
        );
        setState(() {});
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppTheme.primaryPurple.withValues(alpha: 0.2) : Colors.transparent,
              border: isSelected ? Border.all(color: AppTheme.primaryPurple, width: 2) : null,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(height: 4),
          Text(mood, style: TextStyle(fontSize: 10, color: isSelected ? AppTheme.textPrimary : AppTheme.textMuted)),
        ],
      ),
    );
  }

  Widget _pillarCard(String label, IconData icon, int value, int max, Color color, {String suffix = ''}) {
    final pct = max > 0 ? (value / max).clamp(0.0, 1.0) : 0.0;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      opacity: 0.06,
      borderColor: color.withValues(alpha: 0.1),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text('$value$suffix', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 16),
        radius: 16,
        opacity: 0.06,
        borderColor: color.withValues(alpha: 0.1),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
