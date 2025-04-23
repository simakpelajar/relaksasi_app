import 'package:flutter/material.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';

class JournalDetailHeader extends StatelessWidget {
  final Journal journal;

  const JournalDetailHeader({
    Key? key,
    required this.journal,
  }) : super(key: key);

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return Colors.green[700]!;
      case 'sedih':
        return Colors.blue[700]!;
      case 'marah':
        return Colors.red[700]!;
      case 'cemas':
        return Colors.orange[700]!;
      case 'tenang':
        return Colors.teal[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return Icons.sentiment_very_satisfied;
      case 'sedih':
        return Icons.sentiment_dissatisfied;
      case 'marah':
        return Icons.sentiment_very_dissatisfied;
      case 'cemas':
        return Icons.sentiment_neutral;
      case 'tenang':
        return Icons.sentiment_satisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color moodColor = _getMoodColor(journal.mood);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: moodColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: moodColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getMoodIcon(journal.mood),
                      color: moodColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      journal.mood,
                      style: TextStyle(
                        color: moodColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    journal.date,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ditulis pada ${_formatCreatedAt(journal.createdAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  String _formatCreatedAt(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }
}