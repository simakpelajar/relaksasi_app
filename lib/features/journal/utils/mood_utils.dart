import 'package:flutter/material.dart';

/// Kelas utilitas untuk mengelola fungsi terkait mood
class MoodUtils {
  /// Mendapatkan warna berdasarkan jenis mood
  static Color getMoodColor(String mood) {
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

  /// Mendapatkan ikon berdasarkan jenis mood
  static IconData getMoodIcon(String mood) {
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

  /// Mendapatkan deskripsi berdasarkan mood
  static String getMoodDescription(String mood) {
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
  
  /// Mendapatkan saran berdasarkan mood
  static String getMoodAdvice(String mood) {
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

  /// Mendapatkan gradient berdasarkan mood
  static LinearGradient getGradientForMood(String mood) {
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
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
        );
    }
  }
}