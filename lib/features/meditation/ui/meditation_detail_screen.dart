import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:relax_fik/features/alarm/ui/add_alarm_screen.dart';
import 'package:relax_fik/features/meditation/models/meditation_model.dart';
import 'package:relax_fik/features/meditation/services/audio_player_service.dart';
import 'package:relax_fik/features/meditation/widgets/category_gradients.dart';

class MeditationDetailScreen extends StatefulWidget {
  final Meditation meditation;

  const MeditationDetailScreen({
    Key? key,
    required this.meditation,
  }) : super(key: key);

  @override
  State<MeditationDetailScreen> createState() => _MeditationDetailScreenState();
}

class _MeditationDetailScreenState extends State<MeditationDetailScreen> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupAudioPlayer();
    _checkIfAlreadyPlaying();
    
    // Auto-play audio ketika layar detail dibuka
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!_isPlaying) {
        _playAudio();
      }
    });
  }

  void _checkIfAlreadyPlaying() {
    // Check if the current meditation is already playing
    if (_audioPlayerService.currentMeditationTitle == widget.meditation.title) {
      setState(() {
        _isPlaying = _audioPlayerService.isPlaying;
        _position = _audioPlayerService.position;
        _duration = _audioPlayerService.duration;
      });
    }
  }

  void _setupAudioPlayer() {
    _audioPlayerService.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayerService.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayerService.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });
  }

  void _playAudio() {
    _audioPlayerService.play(
      widget.meditation.audioPath,
      meditationTitle: widget.meditation.title
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Color _getCategoryColor(String category) {
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

  Widget _getCategoryIcon(String category) {
    Color iconColor = _getCategoryColor(category);
    
    switch (category.toLowerCase()) {
      case 'relaxation':
        return Icon(Icons.self_improvement, size: 20, color: iconColor);
      case 'focus':
        return Icon(Icons.center_focus_strong, size: 20, color: iconColor);
      case 'sleep':
        return Icon(Icons.nightlight_round, size: 20, color: iconColor);
      case 'alam':
        return Icon(Icons.forest, size: 20, color: iconColor);
      case 'instrumental':
        return Icon(Icons.music_note, size: 20, color: iconColor);
      case 'perkotaan yang tenang':
        return Icon(Icons.location_city, size: 20, color: iconColor);
      case 'imajinatif':
        return Icon(Icons.cloud, size: 20, color: iconColor);
      default:
        return Icon(Icons.category, size: 20, color: iconColor);
    }
  }

  @override
  void dispose() {
    // We should NOT dispose the audio service since it's a singleton
    // and might be used by other screens
    // Instead, just unsubscribe from any listeners we've added
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = CategoryGradients.getGradientForCategory(widget.meditation.category);
    final categoryColor = _getCategoryColor(widget.meditation.category);
    
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.meditation.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAlarmScreen(meditation: widget.meditation),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      widget.meditation.imagePath,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.meditation.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.15),
                                  border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _getCategoryIcon(widget.meditation.category),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.meditation.category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: categoryColor.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.timer, 
                                size: 20, 
                                color: Colors.white.withOpacity(0.6)
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _formatDuration(_duration),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.meditation.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
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
                      max: _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1,
                      value: _position.inSeconds.toDouble() > _duration.inSeconds.toDouble() 
                          ? _duration.inSeconds.toDouble() 
                          : _position.inSeconds.toDouble(),
                      onChanged: (value) {
                        final position = Duration(seconds: value.toInt());
                        _audioPlayerService.seek(position);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
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
                            _audioPlayerService.seek(Duration(seconds: _position.inSeconds - 10));
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
                        onTap: () {
                          if (_isPlaying) {
                            _audioPlayerService.pause();
                          } else {
                            _playAudio();
                          }
                        },
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
                            _isPlaying ? Icons.pause : Icons.play_arrow,
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
                            _audioPlayerService.seek(Duration(seconds: _position.inSeconds + 10));
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
            ),
          ],
        ),
      ),
    );
  }
}