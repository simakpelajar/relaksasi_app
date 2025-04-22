import 'package:flutter/material.dart';
import 'package:relax_fik/core/theme/app_theme.dart';

class StyledCard extends StatelessWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final EdgeInsets padding;
  final double elevation;
  final double borderRadius;
  final VoidCallback? onTap;

  const StyledCard({
    Key? key,
    required this.child,
    this.gradientColors,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 8,
    this.borderRadius = 20,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: elevation,
          borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: gradientColors != null
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors!,
                    )
                  : null,
              color: gradientColors == null ? AppTheme.cardColor : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}