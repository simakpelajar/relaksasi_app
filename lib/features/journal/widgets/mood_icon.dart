import 'package:flutter/material.dart';

class MoodIcon extends StatelessWidget {
  final String mood;
  final double size;

  const MoodIcon({
    Key? key,
    required this.mood,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getMoodColor(mood).withOpacity(0.2),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: _getMoodColor(mood),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Icon(
          _getMoodIcon(mood),
          color: _getMoodColor(mood),
          size: size * 0.6,
        ),
      ),
    );
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

  IconData _getMoodIcon(String mood) {
    final Map<String, IconData> moodIcons = {
      'Senang': Icons.sentiment_very_satisfied,
      'Sedih': Icons.sentiment_dissatisfied,
      'Marah': Icons.mood_bad,
      'Cemas': Icons.sentiment_neutral,
      'Tenang': Icons.sentiment_satisfied,
    };
    
    return moodIcons[mood] ?? Icons.mood;
  }
}