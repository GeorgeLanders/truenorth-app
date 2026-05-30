import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class AICoachService {
  static final AICoachService _instance = AICoachService._();
  factory AICoachService() => _instance;
  AICoachService._();

  String _apiKey = '';
  String _model = 'deepseek/deepseek-v4-flash-free';
  String _userName = 'there';
  
  // OpenRouter endpoint
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  void configure(String apiKey, String model) {
    _apiKey = apiKey;
    _model = model;
  }

  void setUserName(String name) {
    _userName = name.isNotEmpty ? name : 'there';
  }

  String get apiKey => _apiKey;
  String get model => _model;
  bool get isConfigured => _apiKey.isNotEmpty;

  // System prompt for the AI coach
  String _getSystemPrompt() {
    return '''You are TrueNorth Coach, a warm, empathetic wellness coach for an app called TrueNorth. Your user's name is $_userName — use their name naturally in conversation to make it personal.

Core principles:
- NEVER shame, guilt, or pressure. No "cheat days" or "bad foods."
- Celebrate small wins. Progress over perfection.
- Be warm, supportive, and practical.
- Suggest small, achievable steps.
- If someone is struggling, offer kindness first, advice second.
- Keep responses concise (2-4 sentences) and encouraging.
- Never give medical advice. Suggest consulting a doctor for medical concerns.
- Use the app's features: journaling, movement library, nourish log, SOS grounding.
- Address the user by their name ($_userName) occasionally to keep it personal.

Tone: Warm, supportive, like a kind friend who believes in you completely. Use casual language, occasional emojis. Make $_userName feel seen and capable.''';
  }

  // Local fallback responses when no API key is configured
  static final List<String> _localResponses = [
    "You're showing up for yourself today, and that's a huge win. What's one small thing you can do that feels good right now?",
    "Progress isn't a straight line, and that's okay. You're exactly where you need to be. What's one thing that went well today?",
    "I'm really proud of you for checking in. Remember: rest is productive too. How's your energy today?",
    "Every step counts, even the tiny ones. You don't have to do it all at once. What feels manageable today?",
    "You deserve kindness — especially from yourself. If a friend said what you're thinking, what would you tell them?",
    "Hydration check! 💧 Have you had water recently? Your body loves you for it.",
    "Movement doesn't have to be intense. A gentle stretch, a short walk, or even some deep breathing counts. What sounds good?",
    "Your journey is unique to you. Comparing yourself to others just steals your joy. You're doing great — keep going at your own pace.",
    "Some days are about showing up, not crushing it. And showing up is enough. I see you.",
    "You're building habits that will last a lifetime. That takes time and patience. Be as kind to yourself as you would be to a friend starting this journey.",
  ];

  String getJournalPrompt() {
    final prompts = [
      'What made you smile today, even just a little?',
      'How does your body feel right now? No judgment — just notice.',
      'What\'s one thing you appreciate about yourself today?',
      'Write about a time you felt truly at peace.',
      'What kindness did you show yourself today?',
      'Describe your energy today in a color or shape.',
      'What\'s one small win from today, even if it feels tiny?',
      'If your inner critic had a voice, what would you say back?',
      'What does "enough" feel like to you today?',
      'Write about something you\'re looking forward to.',
    ];
    return prompts[DateTime.now().day % prompts.length];
  }

  Future<String> getResponse(String userMessage) async {
    // If no API key, use local fallback responses
    if (_apiKey.isEmpty) {
      return _getLocalResponse(userMessage);
    }

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
          'HTTP-Referer': 'truenorth-app://',
          'X-Title': 'TrueNorth Wellness',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': _getSystemPrompt()},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        return 'Hmm, I had trouble connecting. Let me try a different approach: ${_getLocalResponse(userMessage)}';
      }
    } catch (e) {
      return _getLocalResponse(userMessage);
    }
  }

  String _getLocalResponse(String message) {
    final random = Random();
    return _localResponses[random.nextInt(_localResponses.length)];
  }

  List<String> get quickPrompts => [
    "I'm feeling a bit overwhelmed today",
    "What's a good first step for me?",
    "I need help with motivation",
    "How can I be kinder to myself?",
    "Suggest a gentle movement",
    "I feel like I'm not making progress",
  ];
}
