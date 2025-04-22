// lib/features/journal/data/journal_database.dart


import '../../../core/database/database_helper.dart';

class JournalDatabase {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertJournal(Map<String, dynamic> journal) async {
    final db = await _databaseHelper.database;
    return await db.insert('journals', journal);
  }

  Future<List<Map<String, dynamic>>> getJournals() async {
    final db = await _databaseHelper.database;
    return await db.query('journals', orderBy: 'date DESC');
  }

  Future<Map<String, dynamic>?> getJournal(int id) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'journals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateJournal(Map<String, dynamic> journal) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'journals',
      journal,
      where: 'id = ?',
      whereArgs: [journal['id']],
    );
  }

  Future<int> deleteJournal(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('journals', where: 'id = ?', whereArgs: [id]);
  }
  
  Future<List<Map<String, dynamic>>> getJournalsByDateRange(String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    return await db.query(
      'journals',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date DESC',
    );
  }
  
  Future<List<Map<String, dynamic>>> getJournalsByMood(String mood) async {
    final db = await _databaseHelper.database;
    return await db.query(
      'journals',
      where: 'mood = ?',
      whereArgs: [mood],
      orderBy: 'date DESC',
    );
  }
  
  Future<Map<String, int>> getMoodStats(String startDate, String endDate) async {
    final db = await _databaseHelper.database;
    final results = await db.rawQuery('''
      SELECT mood, COUNT(*) as count
      FROM journals
      WHERE date BETWEEN ? AND ?
      GROUP BY mood
    ''', [startDate, endDate]);
    
    Map<String, int> stats = {};
    for (var result in results) {
      stats[result['mood'] as String] = result['count'] as int;
    }
    return stats;
  }
}