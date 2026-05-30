import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/ai_coach_service.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'widgets/animated_background.dart';
import 'widgets/app_nav_shell.dart';

class TrueNorthApp extends StatefulWidget {
  const TrueNorthApp({super.key});

  @override
  State<TrueNorthApp> createState() => _TrueNorthAppState();
}

class _TrueNorthAppState extends State<TrueNorthApp> {
  final _storage = StorageService();
  bool _loading = true;
  bool _onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    // Restore API key if saved
    final savedKey = await _storage.getApiKey();
    final savedModel = await _storage.getModel();
    if (savedKey.isNotEmpty) {
      AICoachService().configure(savedKey, savedModel);
    }
    
    final user = _storage.loadUserData();
    setState(() {
      _onboardingComplete = user.onboardingComplete;
      _loading = false;
    });
  }

  void _finishOnboarding() {
    setState(() => _onboardingComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrueNorth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: _loading
          ? const Scaffold(
              backgroundColor: AppTheme.deepSpace,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryPurple),
              ),
            )
          : _onboardingComplete
              ? const AnimatedBackground(
                  blur: false,
                  child: AppShell(),
                )
              : OnboardingScreen(onComplete: _finishOnboarding),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppNavShell();
  }
}
