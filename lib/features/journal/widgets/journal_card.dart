import 'package:flutter/material.dart';
import 'package:relax_fik/core/theme/app_theme.dart';
import 'package:relax_fik/features/journal/models/journal_model.dart';
import 'package:relax_fik/features/journal/widgets/mood_icon.dart';

class JournalCard extends StatelessWidget {
  final Journal journal;
  final VoidCallback onTap;

  const JournalCard({
    Key? key,
    required this.journal,
    required this.onTap,
  }) : super(key: key);

  // Get gradient based on mood
  LinearGradient _getGradientForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'senang':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[800]!, Colors.blue[400]!],
        );
      case 'sedih':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo[900]!, Colors.indigo[400]!],
        );
      case 'marah':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red[900]!, Colors.red[400]!],
        );
      case 'cemas':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[900]!, Colors.orange[400]!],
        );
      case 'tenang':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal[800]!, Colors.teal[400]!],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.meditationGradients[0],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: _getGradientForMood(journal.mood),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Decorative elements
              Positioned(
                top: -15,
                right: -15,
                child: Opacity(
                  opacity: 0.15,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: -25,
                left: -25,
                child: Opacity(
                  opacity: 0.1,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, 
                                size: 14, 
                                color: _getMoodColor(journal.mood),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                journal.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getMoodColor(journal.mood),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: MoodIcon(mood: journal.mood, size: 30),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      journal.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Baca',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}