import 'package:flutter/material.dart';
import 'package:relax_fik/features/journal/utils/mood_utils.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;
  final List<String> moods;

  const MoodSelector({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
    required this.moods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = mood == selectedMood;
          final moodColor = MoodUtils.getMoodColor(mood);
          
          return GestureDetector(
            onTap: () => onMoodSelected(mood),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? moodColor.withOpacity(0.2) : const Color.fromARGB(255, 222, 222, 222),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? moodColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MoodUtils.getMoodIcon(mood),
                    color: moodColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    mood,
                    style: TextStyle(
                      color: isSelected ? moodColor : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}