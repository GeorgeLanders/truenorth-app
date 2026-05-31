import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});
  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTrigger = 'general';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('SOS Grounding', style: TextStyle(color: AppTheme.textPrimary)),
        backgroundColor: AppTheme.warmCoral.withValues(alpha: 0.1),
      ),
      body: Column(
        children: [
          // Trigger categories
          Container(
            padding: const EdgeInsets.all(20),
            color: AppTheme.warmCoral.withValues(alpha: 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What are you feeling?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _triggerChip('General', 'general', Icons.person),
                      const SizedBox(width: 8),
                      _triggerChip('Body Image', 'body_image', Icons.face),
                      const SizedBox(width: 8),
                      _triggerChip('Overwhelm', 'overwhelm', Icons.psychology),
                      const SizedBox(width: 8),
                      _triggerChip('Food/Eating', 'food', Icons.restaurant),
                      const SizedBox(width: 8),
                      _triggerChip('Sleepless', 'sleepless', Icons.nightlight_round),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBreathing(_selectedTrigger),
                _buildGrounding(_selectedTrigger),
                _buildResources(),
              ],
            ),
          ),
          // Tabs
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.glassBorder)),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.warmCoral,
              labelColor: AppTheme.warmCoral,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(icon: Icon(Icons.air), text: 'Breathe'),
                Tab(icon: Icon(Icons.healing), text: 'Ground'),
                Tab(icon: Icon(Icons.support), text: 'Support'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _triggerChip(String label, String value, IconData icon) {
    final isSelected = _selectedTrigger == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTrigger = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.warmCoral.withValues(alpha: 0.2) : AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppTheme.warmCoral : AppTheme.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? AppTheme.warmCoral : Colors.white60),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 13, color: isSelected ? AppTheme.warmCoral : Colors.white60)),
          ],
        ),
      ),
    );
  }

  // --- Breathing Exercise ---
  Widget _buildBreathing(String trigger) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: BreathingExercise(trigger: trigger),
      ),
    );
  }

  // --- 5-4-3-2-1 Grounding ---
  Widget _buildGrounding(String trigger) {
    final triggerMessages = {
      'body_image': 'This exercise helps you reconnect with your body as it is, right now — not how you think it should be.',
      'overwhelm': 'When everything feels like too much, your senses can anchor you. Let\'s find five things together.',
      'food': 'After eating, sometimes we need to come back to the present. This grounding is about noticing, not judging.',
      'sleepless': 'If your mind is racing, this can help quiet the noise and bring you back to your body.',
      'general': 'This technique helps bring you back to the present moment by engaging your senses.',
    };
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('5-4-3-2-1 Grounding', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.softSand)),
          const SizedBox(height: 8),
          Text(
            triggerMessages[trigger] ?? triggerMessages['general']!,
            style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 24),
          _groundingStep('5', 'things you can SEE', Icons.visibility),
          const SizedBox(height: 12),
          _groundingStep('4', 'things you can TOUCH', Icons.touch_app),
          const SizedBox(height: 12),
          _groundingStep('3', 'things you can HEAR', Icons.hearing),
          const SizedBox(height: 12),
          _groundingStep('2', 'things you can SMELL', Icons.air),
          const SizedBox(height: 12),
          _groundingStep('1', 'thing you can TASTE', Icons.tty),
        ],
      ),
    );
  }

  Widget _groundingStep(String number, String label, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 16,
      opacity: 0.08,
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppTheme.warmCoral.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(child: Text(number, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.warmCoral))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                Text('Look around and notice...',
                    style: TextStyle(fontSize: 12, color: AppTheme.softSand.withValues(alpha: 0.5))),
              ],
            ),
          ),
          Icon(icon, color: AppTheme.warmCoral.withValues(alpha: 0.6), size: 24),
        ],
      ),
    );
  }

  // --- Crisis Resources ---
  Widget _buildResources() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('You Are Not Alone', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.softSand)),
          const SizedBox(height: 8),
          Text('If you\'re in crisis or need someone to talk to, these resources are available 24/7.',
              style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.6))),
          const SizedBox(height: 24),
          _resourceCard('988', 'Suicide & Crisis Lifeline', 'Call or text 988 (US)', Icons.phone),
          const SizedBox(height: 12),
          _resourceCard('741741', 'Crisis Text Line', 'Text HOME to 741741', Icons.message),
          const SizedBox(height: 12),
          _resourceCard('1-800-273-8255', 'National Suicide Prevention', 'Available 24/7', Icons.support_agent),
          const SizedBox(height: 12),
          _resourceCard('', 'Find a Therapist', 'Visit Psychology Today or Open Path Collective', Icons.search),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(16),
            opacity: 0.12,
            child: const Text('This app provides general wellness support only. It is not a substitute for professional medical advice, diagnosis, or treatment.',
                style: TextStyle(fontSize: 12, color: AppTheme.softSand, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _resourceCard(String number, String name, String description, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 16,
      opacity: 0.08,
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppTheme.warmCoral.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppTheme.warmCoral, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (number.isNotEmpty)
                  Text(number, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.warmCoral)),
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                Text(description, style: TextStyle(fontSize: 12, color: AppTheme.softSand.withValues(alpha: 0.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Breathing Exercise Widget ---
class BreathingExercise extends StatefulWidget {
  final String trigger;

  const BreathingExercise({super.key, this.trigger = 'general'});

  @override
  State<BreathingExercise> createState() => _BreathingExerciseState();
}

class _BreathingExerciseState extends State<BreathingExercise> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  bool _isActive = false;
  String _phase = 'Tap to begin';
  int _phaseIndex = 0;

  final List<Map<String, dynamic>> _phases = [
    {'text': 'Breathe In...', 'duration': 4, 'scale': 1.3, 'color': AppTheme.warmCoral},
    {'text': 'Hold...', 'duration': 4, 'scale': 1.3, 'color': AppTheme.warmAmber},
    {'text': 'Breathe Out...', 'duration': 6, 'scale': 0.8, 'color': AppTheme.softMint},
    {'text': 'Hold...', 'duration': 2, 'scale': 0.8, 'color': AppTheme.darkTeal},
  ];

  String _getTriggerMessage() {
    switch (widget.trigger) {
      case 'body_image':
        return 'Your body is not a problem to be solved.\nYou are worthy, exactly as you are.';
      case 'overwhelm':
        return 'You\'re safe right now.\nLet\'s take this one breath at a time.';
      case 'food':
        return 'No guilt, no judgment.\nJust notice how you feel right now.';
      case 'sleepless':
        return 'Rest is not a reward — it\'s a right.\nLet your mind slow down.';
      default:
        return 'You are here, and that is enough.\nBreathe with me.';
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  void _startBreathing() {
    if (_isActive) {
      _animController.stop();
      setState(() {
        _isActive = false;
        _phase = 'Tap to begin';
        _phaseIndex = 0;
      });
      return;
    }
    setState(() => _isActive = true);
    _runPhase();
  }

  void _runPhase() {
    if (_phaseIndex >= _phases.length) {
      _phaseIndex = 0;
    }
    final phase = _phases[_phaseIndex];
    final duration = Duration(seconds: phase['duration'] as int);

    setState(() => _phase = phase['text'] as String);

    _animController.duration = duration;
    _animController.forward(from: 0).then((_) {
      _phaseIndex++;
      if (_phaseIndex >= _phases.length) _phaseIndex = 0;
      _runPhase();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startBreathing,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Personalized trigger message
          Text(
            _getTriggerMessage(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.7), height: 1.4),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _scaleAnim,
            builder: (_, child) {
              final phase = _phaseIndex < _phases.length ? _phases[_phaseIndex] : _phases[0];
              return Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      (phase['color'] as Color).withValues(alpha: 0.3),
                      (phase['color'] as Color).withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                  border: Border.all(color: (phase['color'] as Color).withValues(alpha: 0.3), width: 2),
                ),
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.glassBorder),
                    ),
                    child: Center(
                      child: Text(_phase,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, color: AppTheme.softSand, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(_isActive ? 'Tap to stop' : 'Tap to begin breathing exercise',
              style: TextStyle(fontSize: 13, color: AppTheme.softSand.withValues(alpha: 0.5))),
          if (_isActive)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _breathIndicator('In', 4),
                  const SizedBox(width: 16),
                  _breathIndicator('Hold', 4),
                  const SizedBox(width: 16),
                  _breathIndicator('Out', 6),
                  const SizedBox(width: 16),
                  _breathIndicator('Hold', 2),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _breathIndicator(String label, int seconds) {
    final isCurrentPhase = _isActive && _phaseIndex < _phases.length && _phases[_phaseIndex]['text']?.contains(label) == true;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrentPhase ? AppTheme.warmCoral.withValues(alpha: 0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label, style: TextStyle(fontSize: 12, color: isCurrentPhase ? AppTheme.warmCoral : Colors.white38)),
        ),
        const SizedBox(height: 2),
        Text('${seconds}s', style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.3))),
      ],
    );
  }
}
