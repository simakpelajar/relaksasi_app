import 'package:flutter/material.dart';

class CategoryUtils {
  // Mendapatkan warna untuk kategori
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'relaxation':
        return const Color(0xFF8BBCCC);
      case 'focus':
        return const Color(0xFF9DB2BF);
      case 'sleep':
        return const Color(0xFF78A6C8);
      case 'alam':
        return const Color(0xFF7EA172);
      case 'instrumental':
        return const Color(0xFFB6BBBF);
      case 'perkotaan yang tenang':
        return const Color(0xFF9CA777);
      case 'imajinatif':
        return const Color(0xFFA1CCD1);
      default:
        return const Color(0xFF9DB2BF);
    }
  }

  // Mendapatkan ikon untuk kategori
  static Widget getCategoryIcon(String category, {double size = 20, Color? color}) {
    Color iconColor = color ?? getCategoryColor(category);
    switch (category.toLowerCase()) {
      case 'relaxation':
        return Icon(Icons.self_improvement, size: size, color: iconColor);
      case 'focus':
        return Icon(Icons.center_focus_strong, size: size, color: iconColor);
      case 'sleep':
        return Icon(Icons.nightlight_round, size: size, color: iconColor);
      case 'alam':
        return Icon(Icons.forest, size: size, color: iconColor);
      case 'instrumental':
        return Icon(Icons.music_note, size: size, color: iconColor);
      case 'perkotaan yang tenang':
        return Icon(Icons.location_city, size: size, color: iconColor);
      case 'imajinatif':
        return Icon(Icons.cloud, size: size, color: iconColor);
      default:
        return Icon(Icons.category, size: size, color: iconColor);
    }
  }
}