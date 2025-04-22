import 'package:flutter/material.dart';

class MoodIcon extends StatelessWidget {
  final String mood;
  final double size;
  final Color? color;

  const MoodIcon({
    Key? key,
    required this.mood,
    this.size = 24.0,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getMoodIcon(),
      size: size,
      color: color ?? _getMoodColor(),
    );
  }

  IconData _getMoodIcon() {
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

  Color _getMoodColor() {
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
