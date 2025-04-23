import '../../../../core/database/database_helper.dart';

class MeditationDatabase {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> getMeditations() async {
    final db = await _databaseHelper.database;
    return await db.query('meditations');
  }

  Future<List<Map<String, dynamic>>> getMeditationsByCategory(String category) async {
    final db = await _databaseHelper.database;
    if (category == 'All') {
      return await db.query('meditations');
    }
    return await db.query(
      'meditations',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<Map<String, dynamic>?> getMeditation(int id) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'meditations',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updatePlayCount(int id, int playCount) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'meditations',
      {'playCount': playCount},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<Map<String, dynamic>>> getPopularMeditations({int limit = 5}) async {
    final db = await _databaseHelper.database;
    return await db.query(
      'meditations',
      orderBy: 'playCount DESC',
      limit: limit,
    );
  }
  
  Future<List<String>> getAllCategories() async {
    final db = await _databaseHelper.database;
    final result = await db.rawQuery('SELECT DISTINCT category FROM meditations');
    return result.map((map) => map['category'] as String).toList();
  }
  
  Future<int> insertMeditation(Map<String, dynamic> meditation) async {
    final db = await _databaseHelper.database;
    return await db.insert('meditations', meditation);
  }
  
  Future<int> updateMeditation(Map<String, dynamic> meditation) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'meditations',
      meditation,
      where: 'id = ?',
      whereArgs: [meditation['id']],
    );
  }
  
  Future<int> deleteMeditation(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('meditations', where: 'id = ?', whereArgs: [id]);
  }
}