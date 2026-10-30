import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class AppDatabase {
  static Database? _database;
  static const Uuid _uuid = Uuid();

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'resqnet.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE disaster_events (
            local_id TEXT PRIMARY KEY,
            event_type TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            description TEXT NOT NULL,
            local_created_at TEXT NOT NULL,
            sync_status TEXT NOT NULL DEFAULT 'PENDING'
          )
        ''');
      },
    );
  }

  static Future<int> insertDisasterEvent({
    required String localId,
    required String eventType,
    required double latitude,
    required double longitude,
    required String description,
  }) async {
    final db = await database;

    return await db.insert(
      'disaster_events',
      {
        'local_id': localId,
        'event_type': eventType,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'local_created_at': DateTime.now().toIso8601String(),
        'sync_status': 'PENDING',
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String> saveDisasterEvent({
    required String eventType,
    required double latitude,
    required double longitude,
    required String description,
  }) async {
    final localId = _uuid.v4();

    await insertDisasterEvent(
      localId: localId,
      eventType: eventType,
      latitude: latitude,
      longitude: longitude,
      description: description,
    );

    return localId;
  }

  static Future<List<Map<String, Object?>>> getSavedDisasterEvents() async {
    final db = await database;

    return await db.query(
      'disaster_events',
      orderBy: 'local_created_at DESC',
    );
  }

  static Future<List<Map<String, Object?>>> getPendingDisasterEvents() async {
    final db = await database;

    return await db.query(
      'disaster_events',
      where: 'sync_status = ?',
      whereArgs: ['PENDING'],
      orderBy: 'local_created_at ASC',
    );
  }

  static Future<int> markDisasterEventAsSynced(
    String localId,
  ) async {
    final db = await database;

    return await db.update(
      'disaster_events',
      {'sync_status': 'SYNCED'},
      where: 'local_id = ?',
      whereArgs: [localId],
    );
  }

  static Future<void> debugSavedDisasterEvents() async {
    final events = await getSavedDisasterEvents();

    // ignore: avoid_print
    print('Total saved reports: ${events.length}');

    for (final event in events) {
      // ignore: avoid_print
      print('Saved report: $event');
    }

    debugPrint('Total saved reports: ${events.length}');
  }
}
