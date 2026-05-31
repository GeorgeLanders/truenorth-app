import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/storage_service.dart';
import '../screens/home/dashboard_screen.dart';
import '../screens/movement/movement_library_screen.dart';
import '../screens/nourish/nourish_screen.dart';
import '../screens/ai_coach/ai_coach_screen.dart';
import '../screens/journal/journal_screen.dart';
import '../screens/sos/sos_screen.dart';
import '../screens/profile/profile_screen.dart';

class AppNavShell extends StatefulWidget {
  const AppNavShell({super.key});

  @override
  State<AppNavShell> createState() => _AppNavShellState();
}

class _AppNavShellState extends State<AppNavShell> {
  int _currentIndex = 0;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  void _loadUserName() {
    final user = StorageService().loadUserData();
    if (user.name.isNotEmpty) {
      setState(() => _userName = user.name);
    }
  }

  List<Widget> _screens() => [
    const DashboardScreen(),
    const MovementLibraryScreen(),
    const NourishScreen(),
    AICoachScreen(userName: _userName),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _screens()[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F0B20).withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(
              color: AppTheme.roseGold.withValues(alpha: 0.08),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Colors.transparent,
          selectedItemColor: AppTheme.primaryPurple,
          unselectedItemColor: AppTheme.textMuted,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.compass_calibration_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_run_rounded), label: 'Move'),
            BottomNavigationBarItem(icon: Icon(Icons.local_dining_rounded), label: 'Nourish'),
            BottomNavigationBarItem(icon: Icon(Icons.psychology_rounded), label: 'Coach'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _openMore(context),
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.menu_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _openMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF12122A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            _sheetItem(ctx, Icons.edit_note_rounded, 'Journal', AppTheme.cyanTeal, () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalScreen()));
            }),
            _sheetItem(ctx, Icons.healing_rounded, 'SOS Grounding', AppTheme.warmCoral, () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SOSScreen()));
            }),
            _sheetItem(ctx, Icons.person_rounded, 'Profile & Settings', AppTheme.primaryPurple, () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sheetItem(BuildContext ctx, IconData icon, String label, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(label, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
      onTap: onTap,
    );
  }
}
