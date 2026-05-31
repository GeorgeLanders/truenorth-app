import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';
import '../../services/ai_coach_service.dart';
import '../../models/user_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = StorageService();
  final _coach = AICoachService();
  UserData _user = UserData();
  bool _showApiKey = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _apiKeyCtrl;
  late TextEditingController _modelCtrl;
  late TextEditingController _affirmationCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _apiKeyCtrl = TextEditingController();
    _modelCtrl = TextEditingController(text: 'nvidia/nemotron-3-nano-omni-30b-a3b-reasoning:free');
    _affirmationCtrl = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _apiKeyCtrl.dispose();
    _modelCtrl.dispose();
    _affirmationCtrl.dispose();
    super.dispose();
  }

  void _loadData() {
    _user = _storage.loadUserData();
    _nameCtrl.text = _user.name;
    _affirmationCtrl.text = _user.customAffirmation ?? '';
    _apiKeyCtrl.text = _coach.apiKey;
    _modelCtrl.text = _coach.model;
  }

  Future<void> _saveName() async {
    _user.name = _nameCtrl.text.trim();
    await _storage.saveUserData(_user);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name saved!'), backgroundColor: AppTheme.vibrantGreen),
      );
    }
  }

  Future<void> _saveAffirmation() async {
    _user.customAffirmation = _affirmationCtrl.text.trim();
    await _storage.saveUserData(_user);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Affirmation saved!'), backgroundColor: AppTheme.vibrantGreen),
      );
    }
  }

  Future<void> _saveApiSettings() async {
    final key = _apiKeyCtrl.text.trim();
    final model = _modelCtrl.text.trim();
    
    await _storage.saveApiKey(key);
    await _storage.saveModel(model);
    _coach.configure(key, model.isNotEmpty ? model : 'deepseek/deepseek-v4-flash-free');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(key.isNotEmpty ? 'DeepSeek V4 connected! 🤖' : 'API key cleared'),
          backgroundColor: AppTheme.primaryPurple,
        ),
      );
    }
  }

  static String _goalLabel(String id) {
    switch (id) {
      case 'energy': return 'More energy to get through my day';
      case 'sleep': return 'Better quality sleep and deeper rest';
      case 'movement': return 'Moving my body in a way that feels good';
      case 'food': return 'A more mindful relationship with food';
      case 'confidence': return 'Building body confidence and self-trust';
      default: return id;
    }
  }

  static IconData _goalIcon(String id) {
    switch (id) {
      case 'energy': return Icons.bolt;
      case 'sleep': return Icons.nightlight_round;
      case 'movement': return Icons.directions_run;
      case 'food': return Icons.restaurant;
      case 'confidence': return Icons.favorite_outline;
      default: return Icons.flag;
    }
  }

  Widget _goalChip(String id) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.warmGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warmGold.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_goalIcon(id), size: 14, color: AppTheme.warmGold),
          const SizedBox(width: 6),
          Text(_goalLabel(id), style: const TextStyle(fontSize: 12, color: AppTheme.warmGold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            GlassCard(
              opacity: 0.06,
              borderColor: AppTheme.primaryPurple.withValues(alpha: 0.15),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.primaryPurple, AppTheme.warmCoral],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.3), blurRadius: 16)],
                    ),
                    child: Center(
                      child: Text(
                        _user.name.isNotEmpty ? _user.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Your name',
                      hintStyle: TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _saveName(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_user.streak} day streak 🔥',
                    style: const TextStyle(color: AppTheme.warmCoral, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveName,
                      icon: const Icon(Icons.save_rounded, size: 16),
                      label: const Text('Save Profile'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Your Goals
            const Text('🎯 Your Goals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            Text('${_user.goals.length} goal${_user.goals.length == 1 ? '' : 's'} selected', style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 12),
            GlassCard(
              opacity: 0.06,
              borderColor: AppTheme.warmGold.withValues(alpha: 0.15),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _user.goals.map((id) => _goalChip(id)).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // AI Coach Settings
            const Text('🤖 AI Coach (NVIDIA Nemotron)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 4),
            const Text('Your AI Coach runs on your Render server. These settings are for the direct fallback.', style: TextStyle(fontSize: 12, color: AppTheme.textMuted)),
            const SizedBox(height: 12),

            GlassCard(
              opacity: 0.06,
              borderColor: AppTheme.primaryPurple.withValues(alpha: 0.15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // API Key
                  const Text('API Key', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _apiKeyCtrl,
                          obscureText: !_showApiKey,
                          style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'sk-or-...',
                            hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showApiKey ? Icons.visibility_off : Icons.visibility,
                                color: AppTheme.textMuted, size: 18,
                              ),
                              onPressed: () => setState(() => _showApiKey = !_showApiKey),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Model
                  const Text('Model', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _modelCtrl,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'deepseek/deepseek-v4-flash-free',
                      hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Default: Uses Render server. Fallback model shown here if you configure a key above.', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveApiSettings,
                      icon: Icon(
                        _apiKeyCtrl.text.isNotEmpty ? Icons.check_circle_rounded : Icons.link_rounded,
                        size: 16,
                      ),
                      label: Text(_apiKeyCtrl.text.isNotEmpty ? 'Save Fallback Settings' : 'Save Settings'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _apiKeyCtrl.text.isNotEmpty ? AppTheme.vibrantGreen : AppTheme.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Custom Affirmation
            const Text('✨ Daily Affirmation', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            GlassCard(
              opacity: 0.06,
              borderColor: AppTheme.warmGold.withValues(alpha: 0.15),
              child: Column(
                children: [
                  TextField(
                    controller: _affirmationCtrl,
                    maxLines: 3,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Write your own daily affirmation...',
                      hintStyle: TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveAffirmation,
                      icon: const Icon(Icons.favorite_rounded, size: 16),
                      label: const Text('Save Affirmation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.warmGold,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Data Management
            const Text('⚙️ Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            const SizedBox(height: 12),
            GlassCard(
              opacity: 0.06,
              child: Column(
                children: [
                  _dataButton(Icons.refresh_rounded, 'Reset Today\'s Data', AppTheme.warmCoral, _resetDaily),
                  const Divider(color: Colors.white12, height: 1),
                  _dataButton(Icons.delete_forever_rounded, 'Erase All Data', AppTheme.warmCoral, _eraseAll),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _dataButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
      onTap: onTap,
    );
  }

  Future<void> _resetDaily() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Today?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('This will clear today\'s water, mood, and habits.', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppTheme.textMuted))),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.resetDailyData();
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Today\'s data reset'), backgroundColor: AppTheme.cyanTeal),
        );
      }
    }
  }

  Future<void> _eraseAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Erase Everything?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text('This will delete ALL your data — journal, meals, habits, everything. This cannot be undone.', style: TextStyle(color: AppTheme.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel', style: TextStyle(color: AppTheme.textMuted))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.warmCoral),
            child: const Text('Erase All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.eraseAllData();
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data erased'), backgroundColor: AppTheme.warmCoral),
        );
      }
    }
  }
}
