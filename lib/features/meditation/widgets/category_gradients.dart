import 'package:flutter/material.dart';

class CategoryGradients {
  // Map kategori ke gradient colors
  static const Map<String, List<Color>> gradients = {
    'All': [Color(0xFF5263F3), Color(0xFF6E7BFF)],
    'Alam': [Color(0xFF00E1FD), Color(0xFF00B8BA)],
    'Instrumental': [Color(0xFFFE6197), Color(0xFFFF8867)],
    'Perkotaan yang tenang': [Color(0xFF4E65FF), Color(0xFF92EFFD)],
    'Imajinatif': [Color(0xFFFF61D2), Color(0xFFFF8980)],
  };

  // Mendapatkan gradient berdasarkan kategori
  static List<Color> getGradientForCategory(String category) {
    return gradients[category] ?? gradients['All']!;
  }
}