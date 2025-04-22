import 'package:relax_fik/features/meditation/database/meditation_database.dart';
import 'package:relax_fik/features/meditation/models/meditation_model.dart';

class MeditationService {
  final MeditationDatabase _meditationDatabase = MeditationDatabase();

  Future<List<Meditation>> getMeditations() async {
    final meditationMaps = await _meditationDatabase.getMeditations();
    return meditationMaps.map((map) => Meditation.fromMap(map)).toList();
  }

  Future<List<Meditation>> getMeditationsByCategory(String category) async {
    final meditationMaps = await _meditationDatabase.getMeditationsByCategory(category);
    return meditationMaps.map((map) => Meditation.fromMap(map)).toList();
  }

  Future<Meditation?> getMeditation(int id) async {
    final meditationMap = await _meditationDatabase.getMeditation(id);
    if (meditationMap == null) return null;
    return Meditation.fromMap(meditationMap);
  }
  
  // Metode untuk menambah play count
  Future<bool> incrementPlayCount(int meditationId) async {
    try {
      final meditationMap = await _meditationDatabase.getMeditation(meditationId);
      if (meditationMap == null) return false;
      
      final meditation = Meditation.fromMap(meditationMap);
      final updatedPlayCount = meditation.playCount + 1;
      
      await _meditationDatabase.updatePlayCount(meditationId, updatedPlayCount);
      return true;
    } catch (e) {
      print('Error incrementing play count: $e');
      return false;
    }
  }
}