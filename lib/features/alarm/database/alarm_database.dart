
import '../../../core/database/database_helper.dart';

class AlarmDatabase {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> insertAlarm(Map<String, dynamic> alarm) async {
    final db = await _databaseHelper.database;
    return await db.insert('alarms', alarm);
  }

  Future<List<Map<String, dynamic>>> getAlarms() async {
    final db = await _databaseHelper.database;
    return await db.query('alarms', orderBy: 'date ASC, time ASC');
  }

  Future<Map<String, dynamic>?> getAlarm(int id) async {
    final db = await _databaseHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateAlarm(Map<String, dynamic> alarm) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'alarms',
      alarm,
      where: 'id = ?',
      whereArgs: [alarm['id']],
    );
  }

  Future<int> deleteAlarm(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('alarms', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleAlarmStatus(int id, int isActive) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'alarms',
      {'is_active': isActive},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  Future<List<Map<String, dynamic>>> getActiveAlarms() async {
    final db = await _databaseHelper.database;
    return await db.query(
      'alarms',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'date ASC, time ASC',
    );
  }
  
  Future<List<Map<String, dynamic>>> getAlarmsByMeditationId(int meditationId) async {
    final db = await _databaseHelper.database;
    return await db.query(
      'alarms',
      where: 'meditation_id = ?',
      whereArgs: [meditationId],
      orderBy: 'date ASC, time ASC',
    );
  }
  
  Future<List<Map<String, dynamic>>> getAlarmsWithMeditationDetails() async {
    final db = await _databaseHelper.database;
    return await db.rawQuery('''
      SELECT a.*, m.title as meditation_title, m.audio_path, m.image_path
      FROM alarms a
      LEFT JOIN meditations m ON a.meditation_id = m.id
      ORDER BY a.date ASC, a.time ASC
    ''');
  }
  
  Future<int> deleteAllAlarms() async {
    final db = await _databaseHelper.database;
    return await db.delete('alarms');
  }
}