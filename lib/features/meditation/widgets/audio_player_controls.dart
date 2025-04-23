import 'package:flutter/material.dart';
import 'package:relax_fik/features/meditation/services/audio_player_service.dart';
import 'package:relax_fik/core/utils/category_utils.dart';

class AudioPlayerControls extends StatelessWidget {
  final AudioPlayerService audioPlayerService;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final String category;
  final Function() onPlayPause;

  const AudioPlayerControls({
    Key? key,
    required this.audioPlayerService,
    required this.isPlaying,
    required this.position,
    required this.duration,
    required this.category,
    required this.onPlayPause,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryUtils.getCategoryColor(category);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: categoryColor.withOpacity(0.8),
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: categoryColor.withOpacity(0.2),
            ),
            child: Slider(
              min: 0,
              max: duration.inSeconds.toDouble() > 0 ? duration.inSeconds.toDouble() : 1,
              value: position.inSeconds.toDouble() > duration.inSeconds.toDouble() 
                  ? duration.inSeconds.toDouble() 
                  : position.inSeconds.toDouble(),
              onChanged: (value) {
                final newPosition = Duration(seconds: value.toInt());
                audioPlayerService.seek(newPosition);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    audioPlayerService.seek(Duration(seconds: position.inSeconds - 10));
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.replay_10,
                      color: Colors.white.withOpacity(0.7),
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: onPlayPause,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    border: Border.all(color: categoryColor.withOpacity(0.4), width: 1.5),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: categoryColor.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: categoryColor,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    audioPlayerService.seek(Duration(seconds: position.inSeconds + 10));
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.forward_10,
                      color: Colors.white.withOpacity(0.7),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}