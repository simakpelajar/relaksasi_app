import 'package:flutter/material.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/services/journal_service.dart';
import 'package:relax_fik/features/journal/ui/add_journal_screen.dart';
import 'package:relax_fik/features/journal/ui/journal_detail_screen.dart';
import 'package:relax_fik/features/journal/widgets/empty_journal_state.dart';
import 'package:relax_fik/features/journal/widgets/journal_card.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();
  List<Journal> _journals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _journals = await _journalService.getJournals();
    } catch (e) {
      debugPrint('Error loading journals: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToAddJournal() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddJournalScreen(),
      ),
    );

    if (result == true) {
      _loadJournals();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ruang Catatan',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _journals.isEmpty
              ? EmptyJournalState(onCreateJournal: _navigateToAddJournal)
              : _buildJournalGrid(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddJournal,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildJournalGrid() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: _journals.length,
        itemBuilder: (context, index) {
          final journal = _journals[index];
          
          return JournalCard(
            journal: journal,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalDetailScreen(journal: journal),
                ),
              );

              if (result == true) {
                _loadJournals();
              }
            },
          );
        },
      ),
    );
  }
}