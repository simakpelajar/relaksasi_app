import 'package:flutter/material.dart';
import 'package:relax_fik/core/utils/category_utils.dart';

class CategoryBadge extends StatelessWidget {
  final String category;
  final double fontSize;
  
  const CategoryBadge({
    Key? key,
    required this.category,
    this.fontSize = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryUtils.getCategoryColor(category);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.15),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryUtils.getCategoryIcon(category),
          const SizedBox(width: 6),
          Text(
            category,
            style: TextStyle(
              fontSize: fontSize,
              color: categoryColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}


class CategorySmallBadge extends StatelessWidget {
  final String category;
  
  const CategorySmallBadge({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryUtils.getCategoryIcon(category, size: 16, color: Colors.white.withOpacity(0.85)),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}