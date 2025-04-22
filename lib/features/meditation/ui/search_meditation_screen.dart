import 'package:flutter/material.dart';
import 'package:relax_fik/features/meditation/models/meditation_model.dart';
import 'package:relax_fik/features/meditation/services/meditation_service.dart';
import 'package:relax_fik/features/meditation/ui/meditation_detail_screen.dart';
import 'package:relax_fik/features/meditation/services/audio_player_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:relax_fik/features/meditation/widgets/category_gradients.dart';

class SearchMeditationScreen extends StatefulWidget {
  const SearchMeditationScreen({Key? key}) : super(key: key);

  @override
  State<SearchMeditationScreen> createState() => _SearchMeditationScreenState();
}

class _SearchMeditationScreenState extends State<SearchMeditationScreen> {
  final MeditationService _meditationService = MeditationService();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final TextEditingController _searchController = TextEditingController();
  List<Meditation> _allMeditations = [];
  List<Meditation> _searchResults = [];
  bool _isLoading = true;
  int? _currentlyPlayingIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadMeditations();
    _setupAudioPlayer();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setupAudioPlayer() {
    _audioPlayerService.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _allMeditations = await _meditationService.getMeditations();
      _searchResults = [];
    } catch (e) {
      debugPrint('Error loading meditations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchMeditations(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allMeditations
            .where((meditation) =>
                meditation.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _getCategoryIcon(String category) {
    Color iconColor = Colors.white.withOpacity(0.85);
    
    switch (category.toLowerCase()) {
      case 'relaxation':
        return Icon(Icons.self_improvement, size: 16, color: iconColor);
      case 'focus':
        return Icon(Icons.center_focus_strong, size: 16, color: iconColor);
      case 'sleep':
        return Icon(Icons.nightlight_round, size: 16, color: iconColor);
      case 'alam':
        return Icon(Icons.forest, size: 16, color: iconColor);
      case 'instrumental':
        return Icon(Icons.music_note, size: 16, color: iconColor);
      case 'perkotaan yang tenang':
        return Icon(Icons.location_city, size: 16, color: iconColor);
      case 'imajinatif':
        return Icon(Icons.cloud, size: 16, color: iconColor);
      default:
        return Icon(Icons.category, size: 16, color: iconColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(top: 40.0, right: 16.0, left: 56.0),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(23),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _searchMeditations,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari meditasi...',
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _searchMeditations('');
                  },
                ),
              ),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        leadingWidth: 56,
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : _searchController.text.isEmpty && _searchResults.isEmpty
                    ? _buildEmptySearchPrompt()
                    : _buildSearchResults(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySearchPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Cari meditasi favoritmu',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan judul atau kata kunci',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return _searchResults.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 80,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ditemukan hasil',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Coba dengan kata kunci lain',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final meditation = _searchResults[index];
              
              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.07),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.white.withOpacity(0.1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MeditationDetailScreen(meditation: meditation),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(16)),
                          child: Image.asset(
                            meditation.imagePath,
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  meditation.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _getCategoryIcon(meditation.category),
                                      const SizedBox(width: 4),
                                      Text(
                                        meditation.category,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.play_circle_outline,
                                      size: 14, 
                                      color: Colors.white.withOpacity(0.6)
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${meditation.playCount} kali diputar',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(12.0),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              _currentlyPlayingIndex == index && _isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_currentlyPlayingIndex == index &&
                                    _isPlaying) {
                                  _audioPlayerService.pause();
                                } else {
                                  _audioPlayerService.play(meditation.audioPath,
                                      meditationTitle: meditation.title);
                                  _currentlyPlayingIndex = index;
                                  _meditationService
                                      .incrementPlayCount(meditation.id!);
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}