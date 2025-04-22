// lib/core/database/database_helper.dart

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'seeders/meditation_seeder.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'meditation_app.db');
    return await openDatabase(
      path,
      version: 6,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Enable foreign keys
    await db.execute('''
      PRAGMA foreign_keys = ON;
    ''');
    
    // Create meditations table
    await db.execute('''
      CREATE TABLE meditations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        category TEXT,
        description TEXT,
        duration INTEGER,
        image_path TEXT,
        audio_path TEXT,
        playCount INTEGER DEFAULT 0
      )
    ''');
    
    // Create alarms table
    await db.execute('''
      CREATE TABLE alarms(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meditation_id INTEGER,
        title TEXT,
        category TEXT,
        time TEXT,
        date TEXT,
        is_active INTEGER DEFAULT 1,
        FOREIGN KEY (meditation_id) REFERENCES meditations (id) ON DELETE CASCADE
      )
    ''');
    
    // Create journals table
    await db.execute('''
      CREATE TABLE journals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        mood TEXT,
        content TEXT,
        created_at TEXT
      )
    ''');
    
    // Insert sample data for meditation using seeder
    await MeditationSeeder.seed(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Database upgrade: from $oldVersion to $newVersion");
    
    // Handle any version upgrade by recreating the tables that might be missing
    try {
      // Check if alarms table exists
      final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='alarms'");
      
      if (tables.isEmpty) {
        print("Creating missing alarms table");
        // Create alarms table since it doesn't exist
        await db.execute('''
          CREATE TABLE IF NOT EXISTS alarms(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            meditation_id INTEGER,
            title TEXT,
            category TEXT,
            time TEXT,
            date TEXT,
            is_active INTEGER DEFAULT 1,
            FOREIGN KEY (meditation_id) REFERENCES meditations (id) ON DELETE CASCADE
          )
        ''');
      }
      
      // Check for journals table too
      final journalTables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='journals'");
      if (journalTables.isEmpty) {
        print("Creating missing journals table");
        await db.execute('''
          CREATE TABLE IF NOT EXISTS journals(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            mood TEXT,
            content TEXT,
            created_at TEXT
          )
        ''');
      }
      
      // For major structural changes, recreate all tables
      if (oldVersion < 7) {
        await db.execute("DROP TABLE IF EXISTS alarms");
        await db.execute("DROP TABLE IF EXISTS journals");
        await db.execute("DROP TABLE IF EXISTS meditations");
        
        await _createDatabase(db, newVersion);
      }
    } catch (e) {
      print("Error during database upgrade: $e");
    }
  }

  // Method untuk menutup koneksi database
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}