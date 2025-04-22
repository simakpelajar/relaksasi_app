import 'package:flutter/material.dart';
import 'package:relax_fik/core/theme/app_theme.dart';

class VolumeControl extends StatelessWidget {
  final double volume;
  final Function(double) onChanged;

  const VolumeControl({
    Key? key,
    required this.volume,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Volume',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                volume <= 0.0 
                    ? Icons.volume_off 
                    : volume <= 0.5 
                        ? Icons.volume_down 
                        : Icons.volume_up,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppTheme.primaryColor,
                    inactiveTrackColor: AppTheme.dividerColor,
                    thumbColor: AppTheme.primaryColor,
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    min: 0.0,
                    max: 1.0,
                    value: volume,
                    onChanged: onChanged,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(volume * 100).toInt()}%',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}