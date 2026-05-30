import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const OnboardingScreen({super.key, required this.onComplete});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Onboarding data
  final TextEditingController _nameController = TextEditingController();
  final List<String> _selectedGoals = [];
  String _mobilityPreference = 'mix';
  bool _agreedToPromise = false;

  final List<Map<String, dynamic>> _goals = [
    {'id': 'energy', 'label': 'More energy to get through my day', 'icon': Icons.bolt},
    {'id': 'sleep', 'label': 'Better quality sleep and deeper rest', 'icon': Icons.nightlight_round},
    {'id': 'movement', 'label': 'Moving my body in a way that feels good', 'icon': Icons.directions_run},
    {'id': 'food', 'label': 'A more mindful relationship with food', 'icon': Icons.restaurant},
    {'id': 'confidence', 'label': 'Building body confidence and self-trust', 'icon': Icons.favorite_outline},
    {'id': 'strength', 'label': 'Strength, stamina, and feeling capable', 'icon': Icons.fitness_center},
    {'id': 'stress', 'label': 'Stress management and inner calm', 'icon': Icons.self_improvement},
    {'id': 'community', 'label': 'Finding a community that understands me', 'icon': Icons.groups},
  ];

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final storage = StorageService();
    final user = storage.loadUserData();
    user.name = _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : 'Friend';
    user.goals = _selectedGoals;
    user.mobilityPreference = _mobilityPreference;
    user.onboardingComplete = true;
    storage.saveUserData(user);
    widget.onComplete();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepNavy,
      body: SafeArea(
        child: Column(
          children: [
            // Progress dots
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _currentPage ? 32 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: i <= _currentPage ? AppTheme.warmCoral : AppTheme.glassBorder,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildWelcomePage(),
                  _buildGoalsPage(),
                  _buildMobilityPage(),
                  _buildPromisePage(),
                ],
              ),
            ),
            // Bottom button
            Padding(
              padding: const EdgeInsets.all(32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _currentPage < 3 ? _nextPage : (_agreedToPromise ? _nextPage : null),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: AppTheme.warmCoral,
                    disabledBackgroundColor: AppTheme.glassBorder,
                  ),
                  child: Text(
                    _currentPage < 3 ? 'Continue' : 'Start My Journey',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.glassBorder, width: 2),
              color: AppTheme.glassWhite,
            ),
            child: const Icon(Icons.explore, size: 48, color: AppTheme.warmCoral),
          ),
          const SizedBox(height: 32),
          const Text('Welcome Home', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.softSand)),
          const SizedBox(height: 16),
          Text(
            'You are more than a number on a scale.\nTrueNorth is a space for sustainable wellness — designed for your body, your pace, your life.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.5),
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'What should I call you? (optional)',
                hintStyle: TextStyle(color: Color(0x66FFFFFF)),
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: false,
              ),
              style: const TextStyle(color: AppTheme.softSand, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildGoalsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text('What does wellness look like for you right now?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
          const SizedBox(height: 8),
          Text('Pick what matters most to you.',
              style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.6))),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: _goals.map((goal) {
                final isSelected = _selectedGoals.contains(goal['id']);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedGoals.remove(goal['id']);
                        } else {
                          _selectedGoals.add(goal['id'] as String);
                        }
                      });
                    },
                    child: GlassCard(
                      opacity: isSelected ? 0.25 : 0.08,
                      radius: 16,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Icon(goal['icon'] as IconData, color: isSelected ? AppTheme.warmCoral : Colors.white60, size: 24),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(goal['label'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isSelected ? AppTheme.softSand : Colors.white70,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                )),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppTheme.warmCoral, size: 22),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilityPage() {
    final options = [
      {'value': 'seated', 'label': 'I prefer seated or low-impact movements', 'icon': Icons.accessible, 'desc': 'Gentle exercises you can do from a chair or with minimal standing'},
      {'value': 'low_impact', 'label': 'I can stand/walk but need joint support', 'icon': Icons.directions_walk, 'desc': 'Supported movements with modifications for comfort'},
      {'value': 'mix', 'label': 'I\'m looking for a mix of everything', 'icon': Icons.self_improvement, 'desc': 'A blend of seated, standing, and gentle movement options'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text("Let's tailor your movement", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
          const SizedBox(height: 8),
          Text('To give you the safest guidance, tell us how you\'d like to move.',
              style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.6))),
          const SizedBox(height: 24),
          ...options.map((opt) {
            final isSelected = _mobilityPreference == opt['value'];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _mobilityPreference = opt['value'] as String),
                child: GlassCard(
                  opacity: isSelected ? 0.25 : 0.08,
                  radius: 16,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppTheme.warmCoral.withValues(alpha: 0.2) : Colors.transparent,
                        ),
                        child: Icon(opt['icon'] as IconData, color: isSelected ? AppTheme.warmCoral : Colors.white60),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opt['label'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? AppTheme.softSand : Colors.white70,
                                )),
                            const SizedBox(height: 4),
                            Text(opt['desc'] as String,
                                style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.4))),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.radio_button_checked, color: AppTheme.warmCoral, size: 22)
                      else
                        const Icon(Icons.radio_button_unchecked, color: Colors.white30, size: 22),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPromisePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.warmCoral.withValues(alpha: 0.15),
            ),
            child: const Icon(Icons.favorite, size: 40, color: AppTheme.warmCoral),
          ),
          const SizedBox(height: 24),
          const Text('Our Promise to You', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.softSand)),
          const SizedBox(height: 20),
          GlassCard(
            padding: const EdgeInsets.all(24),
            opacity: 0.15,
            child: Column(
              children: [
                _promiseItem('No shame', 'This is a judgment-free space for every body'),
                const SizedBox(height: 16),
                _promiseItem('No quick fixes', 'We focus on sustainable habits that last'),
                const SizedBox(height: 16),
                _promiseItem('No judgment', 'You are exactly where you need to be'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => setState(() => _agreedToPromise = !_agreedToPromise),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _agreedToPromise ? AppTheme.warmCoral : Colors.transparent,
                    border: Border.all(color: _agreedToPromise ? AppTheme.warmCoral : Colors.white38, width: 2),
                  ),
                  child: _agreedToPromise ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
                const SizedBox(width: 12),
                Text('I understand and I\'m ready to begin',
                    style: TextStyle(fontSize: 15, color: AppTheme.softSand.withValues(alpha: 0.8))),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _promiseItem(String title, String desc) {
    return Row(
      children: [
        const Icon(Icons.check_circle_outline, color: AppTheme.softMint, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
              Text(desc, style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ],
    );
  }
}
