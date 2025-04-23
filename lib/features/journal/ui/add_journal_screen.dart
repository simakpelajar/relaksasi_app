import 'package:flutter/material.dart';
import 'package:relax_fik/core/utils/date_formatter.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/services/journal_service.dart';
import 'package:relax_fik/features/journal/widgets/date_selector.dart';
import 'package:relax_fik/features/journal/widgets/form_section_container.dart';
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
      try {
        // Try to parse the date if it's in the expected format
        final dateParts = widget.journal!.date.split('/');
        if (dateParts.length == 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);
          _selectedDate = DateTime(year, month, day);
        }
      } catch (e) {
        // If date parsing fails, keep the default (today)
        debugPrint('Error parsing date: $e');
      }
    }
  }

  Future<void> _saveJournal() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan tulis catatan Anda'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
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
        mood: _selectedMood,
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
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
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
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.journal == null ? 'Tambah Catatan' : 'Edit Catatan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          _isLoading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color.fromARGB(255, 255, 0, 0),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _saveJournal,
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
                  // Date section
                  FormSectionContainer(
                    icon: Icons.calendar_today,
                    title: 'Tanggal',
                    child: DateSelector(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Mood section
                  FormSectionContainer(
                    icon: Icons.emoji_emotions,
                    title: 'Suasana Hati',
                    child: MoodSelector(
                      selectedMood: _selectedMood,
                      moods: _moods,
                      onMoodSelected: (mood) {
                        setState(() {
                          _selectedMood = mood;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Content section
                  FormSectionContainer(
                    icon: Icons.edit_note,
                    title: 'Catatan',
                    child: TextField(
                      controller: _contentController,
                      maxLines: 10,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan pikiran dan perasaan Anda di sini...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.05),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _saveJournal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        widget.journal == null ? 'Simpan Catatan' : 'Perbarui Catatan',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}