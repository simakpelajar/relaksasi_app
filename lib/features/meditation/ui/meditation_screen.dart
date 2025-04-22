import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:relax_fik/features/meditation/models/meditation_model.dart';
import 'package:relax_fik/features/meditation/services/meditation_service.dart';
import 'package:relax_fik/features/meditation/services/audio_player_service.dart';
import 'package:relax_fik/features/alarm/services/alarm_service.dart';
import 'package:relax_fik/features/meditation/ui/search_meditation_screen.dart';
import 'package:relax_fik/features/meditation/widgets/category_filter.dart';
import 'package:relax_fik/features/meditation/widgets/meditation_card.dart';
import 'package:relax_fik/features/meditation/widgets/meditation_header.dart';
import 'package:relax_fik/features/meditation/widgets/category_gradients.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({Key? key}) : super(key: key);

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final MeditationService _meditationService = MeditationService();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final AlarmService _alarmService = AlarmService();
  List<Meditation> _meditations = [];
  List<Meditation> _filteredMeditations = [];
  String _selectedCategory = 'All';
  bool _isLoading = true;
  int? _currentlyPlayingIndex;
  bool _isPlaying = false;
  int _alarmCount = 0;

  final List<String> _categories = [
    'All',
    'Alam',
    'Instrumental',
    'Perkotaan yang tenang',
    'Imajinatif',
  ];

  @override
  void initState() {
    super.initState();
    _loadMeditations();
    _loadAlarmCount();
    _setupAudioPlayer();
  }

  Future<void> _loadAlarmCount() async {
    final alarms = await _alarmService.getAlarms();
    setState(() {
      _alarmCount = alarms.length;
    });
  }

  void _setupAudioPlayer() {
    _audioPlayerService.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_selectedCategory == 'All') {
        _meditations = await _meditationService.getMeditations();
      } else {
        _meditations = await _meditationService.getMeditationsByCategory(_selectedCategory);
      }
      _filteredMeditations = _meditations;
    } catch (e) {
      debugPrint('Error loading meditations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Ruang Tenang',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchMeditationScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Menggunakan widget MeditationHeader
                MeditationHeader(
                  alarmCount: _alarmCount,
                ),
                const SizedBox(height: 24),
                
                // Menggunakan widget CategoryFilter
                CategoryFilter(
                  categories: _categories,
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _loadMeditations();
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Daftar meditasi
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildMeditationList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMeditationList() {
    return ListView.builder(
      itemCount: _filteredMeditations.length,
      itemBuilder: (context, index) {
        final meditation = _filteredMeditations[index];
        final gradientColors = CategoryGradients.getGradientForCategory(meditation.category);
        
        // Menggunakan widget MeditationCard
        return MeditationCard(
          meditation: meditation,
          gradientColors: gradientColors,
          isPlaying: _currentlyPlayingIndex == index && _isPlaying,
          onPlayPressed: () {
            setState(() {
              if (_currentlyPlayingIndex == index && _isPlaying) {
                _audioPlayerService.pause();
                _isPlaying = false;
              } else {
                _audioPlayerService.play(
                  meditation.audioPath,
                  meditationTitle: meditation.title
                );
                _currentlyPlayingIndex = index;
                _isPlaying = true;
                _meditationService.incrementPlayCount(meditation.id!);
              }
            });
          },
        );
      },
    );
  }
}