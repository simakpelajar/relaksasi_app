import 'package:flutter/material.dart';
import 'package:relax_fik/core/theme/app_theme.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/services/journal_service.dart';
import 'package:relax_fik/features/journal/ui/add_journal_screen.dart';
import 'package:relax_fik/features/journal/widgets/mood_icon.dart';

class JournalDetailScreen extends StatefulWidget {
  final Journal journal;

  const JournalDetailScreen({
    Key? key,
    required this.journal,
  }) : super(key: key);

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  final JournalService _journalService = JournalService();
  bool _isLoading = false;

  Future<void> _deleteJournal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: const Text('Hapus Catatan', style: TextStyle(color: AppTheme.textColor)),
        content: const Text('Apakah Anda yakin ingin menghapus catatan ini?', 
          style: TextStyle(color: AppTheme.textColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal', style: TextStyle(color: AppTheme.primaryColor)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _journalService.deleteJournal(widget.journal.id!);
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      // Handle error
      debugPrint('Error deleting journal: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus catatan'),
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
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primaryColor;
    final scaffoldBackgroundColor = AppTheme.backgroundColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textColor)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.textColor),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddJournalScreen(journal: widget.journal),
                ),
              );

              if (result == true) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppTheme.textColor),
            onPressed: _isLoading ? null : _deleteJournal,
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
                  // Header with date and mood
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.3),
                          primaryColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: AppTheme.textColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.journal.date,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Catatan Harian',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                       Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                            border: Border.all(
                              color: _getMoodColor(widget.journal.mood).withOpacity(0.5),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              MoodIcon(
                                mood: widget.journal.mood,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.journal.mood,
                                style: TextStyle(
                                  color: _getMoodColor(widget.journal.mood),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                       ),

                      ],
                      
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Content card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes, color: AppTheme.textColor, size: 22),
                            const SizedBox(width: 8),
                            const Text(
                              'Catatan Hari Ini',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textColor,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 30,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            widget.journal.content,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: AppTheme.textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Additional information card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getMoodColor(widget.journal.mood).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: _getMoodColor(widget.journal.mood).withOpacity(0.3),
                          child: Icon(
                            _getMoodIcon(widget.journal.mood),
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getMoodDescription(widget.journal.mood),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getMoodAdvice(widget.journal.mood),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppTheme.textColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return Icons.sentiment_very_satisfied;
      case 'sedih':
        return Icons.sentiment_very_dissatisfied;
      case 'marah':
        return Icons.mood_bad;
      case 'cemas':
        return Icons.sentiment_neutral;
      case 'tenang':
        return Icons.sentiment_satisfied;
      default:
        return Icons.emoji_emotions;
    }
  }
  
  String _getMoodDescription(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return 'Anda merasa senang hari ini';
      case 'sedih':
        return 'Anda merasa sedih hari ini';
      case 'marah':
        return 'Anda merasa marah hari ini';
      case 'cemas':
        return 'Anda merasa cemas hari ini';
      case 'tenang':
        return 'Anda merasa tenang hari ini';
      default:
        return 'Bagaimana perasaan Anda hari ini?';
    }
  }
  
  String _getMoodAdvice(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return 'Bagus! Teruslah pertahankan energi positif ini.';
      case 'sedih':
        return 'Cobalah meditasi atau aktivitas yang Anda sukai.';
      case 'marah':
        return 'Tarik nafas dalam dan coba tenangkan pikiran Anda.';
      case 'cemas':
        return 'Latihan pernapasan bisa membantu mengurangi kecemasan.';
      case 'tenang':
        return 'Sempurna, tetap jaga keseimbangan pikiran Anda.';
      default:
        return 'Tuliskan perasaan Anda setiap hari untuk refleksi diri.';
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return Colors.green;
      case 'sedih':
        return Colors.blue;
      case 'marah':
        return Colors.red;
      case 'cemas':
        return Colors.orange;
      case 'tenang':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
