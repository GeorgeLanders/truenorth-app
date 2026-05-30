import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/user_data.dart';
import '../models/journal_entry.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  Database? _db;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _initDatabase();
  }

  // --- SQLite Database ---
  Future<void> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'truenorth.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE journal_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            text TEXT NOT NULL,
            prompt TEXT,
            mood TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE meal_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            mealType TEXT NOT NULL,
            description TEXT NOT NULL,
            satisfaction INTEGER NOT NULL DEFAULT 3,
            notes TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE daily_logs (
            date TEXT PRIMARY KEY,
            waterCups INTEGER DEFAULT 0,
            sleepHours INTEGER DEFAULT 0,
            movementMinutes INTEGER DEFAULT 0,
            nourishmentCount INTEGER DEFAULT 0,
            mood TEXT
          )
        ''');
      },
    );
  }

  // --- User Data ---
  Future<void> saveUserData(UserData data) async {
    await _prefs!.setString('user_data', jsonEncode(data.toJson()));
  }

  UserData loadUserData() {
    final json = _prefs!.getString('user_data');
    if (json == null) return UserData();
    return UserData.fromJson(jsonDecode(json));
  }

  // --- Journal ---
  Future<int> saveJournalEntry(JournalEntry entry) async {
    return await _db!.insert('journal_entries', entry.toMap());
  }

  Future<List<JournalEntry>> getJournalEntries({int limit = 50}) async {
    final maps = await _db!.query(
      'journal_entries',
      orderBy: 'date DESC',
      limit: limit,
    );
    return maps.map((m) => JournalEntry.fromMap(m)).toList();
  }

  Future<void> deleteJournalEntry(int id) async {
    await _db!.delete('journal_entries', where: 'id = ?', whereArgs: [id]);
  }

  // --- Meal Logs ---
  Future<int> saveMealLog(MealLog log) async {
    return await _db!.insert('meal_logs', log.toMap());
  }

  Future<List<MealLog>> getMealLogs({int limit = 50}) async {
    final maps = await _db!.query(
      'meal_logs',
      orderBy: 'date DESC',
      limit: limit,
    );
    return maps.map((m) => MealLog.fromMap(m)).toList();
  }

  // --- Daily Logs ---
  Future<void> saveDailyLog({
    required String date,
    int? waterCups,
    int? sleepHours,
    int? movementMinutes,
    int? nourishmentCount,
    String? mood,
  }) async {
    final existing = await _db!.query('daily_logs', where: 'date = ?', whereArgs: [date]);
    if (existing.isEmpty) {
      await _db!.insert('daily_logs', {
        'date': date,
        'waterCups': waterCups ?? 0,
        'sleepHours': sleepHours ?? 0,
        'movementMinutes': movementMinutes ?? 0,
        'nourishmentCount': nourishmentCount ?? 0,
        'mood': mood,
      });
    } else {
      final updates = <String, dynamic>{};
      if (waterCups != null) updates['waterCups'] = waterCups;
      if (sleepHours != null) updates['sleepHours'] = sleepHours;
      if (movementMinutes != null) updates['movementMinutes'] = movementMinutes;
      if (nourishmentCount != null) updates['nourishmentCount'] = nourishmentCount;
      if (mood != null) updates['mood'] = mood;
      if (updates.isNotEmpty) {
        await _db!.update('daily_logs', updates, where: 'date = ?', whereArgs: [date]);
      }
    }
  }

  Future<Map<String, dynamic>?> getDailyLog(String date) async {
    final results = await _db!.query('daily_logs', where: 'date = ?', whereArgs: [date]);
    if (results.isEmpty) return null;
    return results.first;
  }

  Future<void> resetDailyData() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    await _db!.delete('daily_logs', where: 'date = ?', whereArgs: [today]);
    final user = loadUserData();
    user.waterCups = 0;
    user.sleepHours = 0;
    user.movementMinutes = 0;
    user.nourishmentCount = 0;
    user.moodToday = null;
    await saveUserData(user);
  }

  Future<void> eraseAllData() async {
    await _db!.delete('journal_entries');
    await _db!.delete('meal_logs');
    await _db!.delete('daily_logs');
    await _prefs!.clear();
  }

  // --- OpenRouter Settings ---
  Future<void> saveApiKey(String key) async {
    await _prefs!.setString('openrouter_api_key', key);
  }

  Future<String> getApiKey() async {
    return _prefs!.getString('openrouter_api_key') ?? '';
  }

  Future<void> saveModel(String model) async {
    await _prefs!.setString('openrouter_model', model);
  }

  Future<String> getModel() async {
    return _prefs!.getString('openrouter_model') ?? 'deepseek/deepseek-v4';
  }
}
