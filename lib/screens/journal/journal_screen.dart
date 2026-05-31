import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';
import '../../services/storage_service.dart';
import '../../services/ai_coach_service.dart';
import '../../models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _storage = StorageService();
  final _coach = AICoachService();
  final _textController = TextEditingController();
  List<JournalEntry> _entries = [];
  String _currentPrompt = '';
  String? _selectedMood;

  @override
  void initState() {
    super.initState();
    _currentPrompt = _coach.getJournalPrompt();
    _loadEntries();
  }

  void _loadEntries() {
    _storage.getJournalEntries().then((entries) {
      setState(() => _entries = entries);
    });
  }

  void _saveEntry() async {
    if (_textController.text.trim().isEmpty) return;
    final entry = JournalEntry(
      date: DateTime.now(),
      text: _textController.text.trim(),
      prompt: _currentPrompt,
      mood: _selectedMood,
    );
    await _storage.saveJournalEntry(entry);
    _textController.clear();
    _selectedMood = null;
    _currentPrompt = _coach.getJournalPrompt();
    _loadEntries();
    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Journal entry saved ✍️'),
          backgroundColor: AppTheme.warmAmber, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(
        title: const Text('Journal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt
            GlassCard(
              padding: const EdgeInsets.all(16),
              opacity: 0.12,
              radius: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppTheme.warmAmber, size: 18),
                          SizedBox(width: 8),
                          Text('Today\'s Prompt', style: TextStyle(fontSize: 13, color: AppTheme.warmAmber, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _currentPrompt = _coach.getJournalPrompt()),
                        child: const Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.white54, size: 16),
                            SizedBox(width: 4),
                            Text('New prompt', style: TextStyle(fontSize: 12, color: Colors.white54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('"$_currentPrompt"',
                      style: const TextStyle(fontSize: 16, color: AppTheme.softSand, fontStyle: FontStyle.italic, height: 1.4)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mood tag
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _moodChip('😊', 'great'),
                  const SizedBox(width: 6),
                  _moodChip('🙂', 'good'),
                  const SizedBox(width: 6),
                  _moodChip('😐', 'okay'),
                  const SizedBox(width: 6),
                  _moodChip('😔', 'low'),
                  const SizedBox(width: 6),
                  _moodChip('😢', 'struggling'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Write area
            GlassCard(
              padding: const EdgeInsets.all(12),
              opacity: 0.06,
              radius: 16,
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Write whatever comes to mind...',
                  hintStyle: TextStyle(color: Color(0x44FFFFFF)),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: AppTheme.softSand, fontSize: 15, height: 1.5),
                maxLines: 6,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _saveEntry,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Save Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warmAmber,
                  foregroundColor: AppTheme.charcoal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Previous entries
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Previous Entries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.softSand)),
                if (_entries.length > 3)
                  GestureDetector(
                    onTap: () => _showAllEntries(),
                    child: Text('View all (${_entries.length})',
                        style: const TextStyle(fontSize: 13, color: AppTheme.warmCoral)),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (_entries.isEmpty)
              GlassCard(
                opacity: 0.06,
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.edit_note, size: 40, color: Colors.white.withValues(alpha: 0.2)),
                      const SizedBox(height: 8),
                      Text('No entries yet.\nYour journal is a safe space.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.5))),
                    ],
                  ),
                ),
              )
            else
              ..._entries.take(3).map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlassCard(
                  padding: const EdgeInsets.all(14),
                  radius: 14,
                  opacity: 0.06,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.formattedDate,
                              style: TextStyle(fontSize: 11, color: AppTheme.softSand.withValues(alpha: 0.5))),
                          if (entry.mood != null)
                            Text({'great':'😊','good':'🙂','okay':'😐','low':'😔','struggling':'😢'}[entry.mood] ?? '',
                                style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(entry.text,
                          maxLines: 3, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.8), height: 1.4)),
                    ],
                  ),
                ),
              )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _moodChip(String emoji, String mood) {
    final isSelected = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = isSelected ? null : mood),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.warmCoral.withValues(alpha: 0.2) : AppTheme.glassWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.warmCoral : AppTheme.glassBorder),
        ),
        child: Text('$emoji $mood',
            style: TextStyle(fontSize: 13, color: isSelected ? AppTheme.warmCoral : Colors.white60)),
      ),
    );
  }

  void _showAllEntries() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => _AllEntriesPage(entries: _entries)));
  }
}

class _AllEntriesPage extends StatelessWidget {
  final List<JournalEntry> entries;
  const _AllEntriesPage({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.deepSpace,
      appBar: AppBar(title: const Text('All Entries')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: entries.length,
        itemBuilder: (_, i) {
          final entry = entries[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GlassCard(
              padding: const EdgeInsets.all(14),
              radius: 14,
              opacity: 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.formattedDate,
                          style: TextStyle(fontSize: 11, color: AppTheme.softSand.withValues(alpha: 0.5))),
                      if (entry.mood != null)
                        Text({'great':'😊','good':'🙂','okay':'😐','low':'😔','struggling':'😢'}[entry.mood] ?? '',
                            style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                  if (entry.prompt != null && entry.prompt!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('"${entry.prompt}"',
                        style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppTheme.softSand.withValues(alpha: 0.4))),
                  ],
                  const SizedBox(height: 6),
                  Text(entry.text,
                      style: TextStyle(fontSize: 14, color: AppTheme.softSand.withValues(alpha: 0.8), height: 1.4)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
