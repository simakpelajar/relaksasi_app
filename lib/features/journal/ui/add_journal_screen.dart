import 'package:flutter/material.dart';
import 'package:relax_fik/core/utils/date_formatter.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/services/journal_service.dart';
import 'package:relax_fik/features/journal/widgets/date_selector.dart';
import 'package:relax_fik/features/journal/widgets/mood_selector.dart';

class AddJournalScreen extends StatefulWidget {
  final Journal? journal;

  const AddJournalScreen({
    Key? key,
    this.journal,
  }) : super(key: key);

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final JournalService _journalService = JournalService();
  final TextEditingController _contentController = TextEditingController();
  
  String _selectedMood = 'Senang';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  final List<String> _moods = ['Senang', 'Sedih', 'Marah', 'Cemas', 'Tenang'];

  @override
  void initState() {
    super.initState();
    
    if (widget.journal != null) {
      _contentController.text = widget.journal!.content;
      _selectedMood = widget.journal!.mood;
    }
  }

  Future<void> _saveJournal() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tulis catatan Anda'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final journal = Journal(
        id: widget.journal?.id,
        date: DateFormatter.formatDate(_selectedDate),
        mood: _selectedMood, // Langsung gunakan mood bahasa Indonesia
        content: _contentController.text,
        createdAt: DateTime.now().toIso8601String(),
      );

      if (widget.journal == null) {
        await _journalService.addJournal(journal);
      } else {
        await _journalService.updateJournal(journal);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error saving journal: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan catatan'),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journal == null ? 'Tambah Catatan' : 'Edit Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isLoading ? null : _saveJournal,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tanggal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DateSelector(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Suasana Hati',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MoodSelector(
                    selectedMood: _selectedMood,
                    moods: _moods,
                    onMoodSelected: (mood) {
                      setState(() {
                        _selectedMood = mood;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Catatan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan pikiran Anda di sini...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveJournal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Simpan Catatan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}