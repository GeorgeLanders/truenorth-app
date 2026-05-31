import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/ai_coach_service.dart';
import '../../screens/profile/profile_screen.dart';

class AICoachScreen extends StatefulWidget {
  final String userName;
  const AICoachScreen({super.key, this.userName = ''});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final _coach = AICoachService();
  final _messages = <_ChatMessage>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadNameAndGreet();
  }

  Future<void> _loadNameAndGreet() async {
    final name = widget.userName.isNotEmpty
        ? widget.userName
        : 'there';
    _coach.setUserName(name);
    final greeting = name == 'there'
        ? 'Hi there! 👋 I\'m your TrueNorth coach. What\'s on your mind today?'
        : 'Hi $name! 👋 Great to see you. How are you feeling today?';
    if (mounted) {
      setState(() {
        _messages.add(_ChatMessage(greeting, false));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _loading) return;

    setState(() {
      _messages.add(_ChatMessage(text.trim(), true));
      _loading = true;
    });
    _controller.clear();
    _scrollToBottom();

    // Track user message in history
    _coach.addToHistory(text.trim(), true);

    // Get response from AI coach
    final response = await _coach.getResponse(text.trim());

    // Track coach response in history
    _coach.addToHistory(response, false);

    setState(() {
      _messages.add(_ChatMessage(response, false));
      _loading = false;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final isConfigured = _coach.isConfigured;

    return SafeArea(
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.3), blurRadius: 12)],
                  ),
                  child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Coach', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    Text(_coach.displayModelName, style: const TextStyle(fontSize: 12, color: AppTheme.textMuted)),
                  ],
                ),
                const Spacer(),
                if (!isConfigured)
                  GestureDetector(
                    onTap: () => _showSetupPrompt(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.warmCoral.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.warmCoral.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: AppTheme.warmCoral, size: 14),
                          SizedBox(width: 4),
                          Text('Setup API', style: TextStyle(color: AppTheme.warmCoral, fontSize: 11)),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                      color: AppTheme.vibrantGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _messages.length + (_loading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return _buildLoadingBubble();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick prompts (show at start)
          if (_messages.length <= 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _coach.quickPrompts.map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(p, style: const TextStyle(fontSize: 12, color: AppTheme.textPrimary)),
                    backgroundColor: AppTheme.glassWhite,
                    side: BorderSide(color: AppTheme.primaryPurple.withValues(alpha: 0.2)),
                    onPressed: () => _sendMessage(p),
                  ),
                )).toList(),
              ),
            ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F0F2E).withValues(alpha: 0.9),
              border: Border(
                top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: isConfigured ? 'Ask me anything...' : 'Type a message...',
                        hintStyle: TextStyle(color: AppTheme.textMuted),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryPurple, AppTheme.primaryPurple.withValues(alpha: 0.8)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.3), blurRadius: 8)],
                  ),
                  child: IconButton(
                    icon: _loading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    onPressed: _loading ? null : () => _sendMessage(_controller.text),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    if (msg.isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primaryPurple, AppTheme.primaryPurple.withValues(alpha: 0.8)],
            ),
            borderRadius: BorderRadius.circular(20).copyWith(bottomRight: Radius.zero),
            boxShadow: [BoxShadow(color: AppTheme.primaryPurple.withValues(alpha: 0.2), blurRadius: 8)],
          ),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          child: Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: Radius.zero),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Text(msg.text, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14)),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20).copyWith(bottomLeft: Radius.zero),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List.generate(3, (i) => TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.3, end: 1.0),
              duration: Duration(milliseconds: 600 + i * 200),
              builder: (_, v, __) => Container(
                margin: const EdgeInsets.only(right: 4),
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple.withValues(alpha: v),
                  shape: BoxShape.circle,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showSetupPrompt() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A3E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Set Up AI Coach', style: TextStyle(color: AppTheme.textPrimary)),
        content: Text(
          'Your AI Coach runs on your Render server, already connected and ready to go.\n\n'
          'For direct OpenRouter access, add your API key in Profile & Settings.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Later', style: TextStyle(color: AppTheme.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Navigate to profile
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => const ProfileScreen(),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Go to Settings'),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  _ChatMessage(this.text, this.isUser);
}
