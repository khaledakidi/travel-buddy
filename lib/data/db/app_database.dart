import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/place.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'travel_buddy.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE saved_places (
            placeId           TEXT PRIMARY KEY,
            name              TEXT NOT NULL,
            address           TEXT NOT NULL,
            latitude          REAL NOT NULL,
            longitude         REAL NOT NULL,
            rating            REAL NOT NULL,
            reviewCount       INTEGER NOT NULL,
            category          TEXT NOT NULL,
            photoUrl          TEXT,
            price             TEXT NOT NULL,
            hours             TEXT NOT NULL,
            hasStudentDiscount INTEGER NOT NULL DEFAULT 0,
            discountText      TEXT,
            isVisited         INTEGER NOT NULL DEFAULT 0,
            savedAt           INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE user_stats (
            id      INTEGER PRIMARY KEY,
            xp      INTEGER NOT NULL DEFAULT 0,
            level   INTEGER NOT NULL DEFAULT 1,
            streak  INTEGER NOT NULL DEFAULT 0,
            lastVisitDate TEXT
          )
        ''');
        // Insert default stats row
        await db.insert('user_stats', {
          'id': 1, 'xp': 0, 'level': 1, 'streak': 0, 'lastVisitDate': null
        });
      },
    );
  }

  // ── Saved Places CRUD ──────────────────────────────

  /// CREATE — save a place
  static Future<void> savePlace(Place place) async {
    final db = await database;
    await db.insert(
      'saved_places',
      place.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _addXp(5); // +5 XP for saving
  }

  /// READ — get all saved places
  static Future<List<Place>> getSavedPlaces() async {
    final db = await database;
    final rows = await db.query('saved_places', orderBy: 'savedAt DESC');
    return rows.map(Place.fromMap).toList();
  }

  /// READ — check if a single place is saved
  static Future<bool> isSaved(String placeId) async {
    final db = await database;
    final rows = await db.query(
      'saved_places',
      where: 'placeId = ?',
      whereArgs: [placeId],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  /// UPDATE — mark a place as visited
  static Future<void> markVisited(String placeId) async {
    final db = await database;
    await db.update(
      'saved_places',
      {'isVisited': 1},
      where: 'placeId = ?',
      whereArgs: [placeId],
    );
    await _addXp(10); // +10 XP for visiting
    await _updateStreak();
  }

  /// DELETE — unsave a place
  static Future<void> unsavePlace(String placeId) async {
    final db = await database;
    await db.delete(
      'saved_places',
      where: 'placeId = ?',
      whereArgs: [placeId],
    );
  }

  // ── XP / Level / Streak ───────────────────────────

  static Future<Map<String, dynamic>> getUserStats() async {
    final db = await database;
    final rows = await db.query('user_stats', where: 'id = 1');
    return rows.first;
  }

  static Future<void> _addXp(int amount) async {
    final db = await database;
    final stats = await getUserStats();
    int xp    = (stats['xp'] as int) + amount;
    int level = _calcLevel(xp);
    await db.update(
      'user_stats',
      {'xp': xp, 'level': level},
      where: 'id = 1',
    );
  }

  static int _calcLevel(int xp) {
    if (xp < 50)  return 1;
    if (xp < 150) return 2;
    if (xp < 300) return 3;
    if (xp < 500) return 4;
    return 5;
  }

  static int xpForNextLevel(int level) {
    switch (level) {
      case 1: return 50;
      case 2: return 150;
      case 3: return 300;
      case 4: return 500;
      default: return 999;
    }
  }

  static Future<void> _updateStreak() async {
    final db   = await database;
    final stats = await getUserStats();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last  = stats['lastVisitDate'] as String?;

    int streak = stats['streak'] as int;
    if (last == null) {
      streak = 1;
    } else if (last == today) {
      // already visited today, no change
    } else {
      final diff = DateTime.now().difference(DateTime.parse(last)).inDays;
      streak = diff == 1 ? streak + 1 : 1;
    }

    await db.update(
      'user_stats',
      {'streak': streak, 'lastVisitDate': today},
      where: 'id = 1',
    );
  }
}
