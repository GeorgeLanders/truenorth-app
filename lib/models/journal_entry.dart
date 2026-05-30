import 'package:intl/intl.dart';

class JournalEntry {
  final int? id;
  final DateTime date;
  final String text;
  final String? prompt;
  final String? mood;

  JournalEntry({
    this.id,
    required this.date,
    required this.text,
    this.prompt,
    this.mood,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'text': text,
    'prompt': prompt,
    'mood': mood,
  };

  factory JournalEntry.fromMap(Map<String, dynamic> map) => JournalEntry(
    id: map['id'] as int?,
    date: DateTime.parse(map['date'] as String),
    text: map['text'] as String,
    prompt: map['prompt'] as String?,
    mood: map['mood'] as String?,
  );
}

class MealLog {
  final int? id;
  final DateTime date;
  final String mealType; // breakfast, lunch, dinner, snack
  final String description;
  final int satisfaction; // 1-5
  final String? notes;

  MealLog({
    this.id,
    required this.date,
    required this.mealType,
    required this.description,
    this.satisfaction = 3,
    this.notes,
  });

  String get formattedDate => DateFormat('MMM d, yyyy').format(date);
  String get formattedTime => DateFormat('h:mm a').format(date);

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'mealType': mealType,
    'description': description,
    'satisfaction': satisfaction,
    'notes': notes,
  };

  factory MealLog.fromMap(Map<String, dynamic> map) => MealLog(
    id: map['id'] as int?,
    date: DateTime.parse(map['date'] as String),
    mealType: map['mealType'] as String,
    description: map['description'] as String,
    satisfaction: map['satisfaction'] as int? ?? 3,
    notes: map['notes'] as String?,
  );
}
