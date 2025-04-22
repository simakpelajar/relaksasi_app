import 'package:relax_fik/features/journal/database/journal_database.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';

class JournalService {
  final JournalDatabase _journalDatabase = JournalDatabase();

  Future<List<Journal>> getJournals() async {
    final journalMaps = await _journalDatabase.getJournals();
    return journalMaps.map((map) => Journal.fromMap(map)).toList();
  }

  Future<Journal?> getJournal(int id) async {
    final journalMap = await _journalDatabase.getJournal(id);
    if (journalMap == null) return null;
    return Journal.fromMap(journalMap);
  }

  Future<int> addJournal(Journal journal) async {
    return await _journalDatabase.insertJournal(journal.toMap());
  }

  Future<int> updateJournal(Journal journal) async {
    return await _journalDatabase.updateJournal(journal.toMap());
  }

  Future<int> deleteJournal(int id) async {
    return await _journalDatabase.deleteJournal(id);
  }
}