import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Zen Meditation',
      'artist': 'Inner Peace',
      'path': 'audio/zen.mp3',
    },
    {
      'title': 'Soul Music',
      'artist': 'Nature Sounds',
      'path': 'audio/soul.mp3',
    },
    {
      'title': 'Rain Melody',
      'artist': 'Relaxing Rain Rhythms',
      'path': 'audio/rain.mp3',
    },
  ];

  int? _selectedTrackIndex;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });
    player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _selectTrack(int index) async {
    // If the same track is selected, just toggle play/pause
    if (_selectedTrackIndex == index) {
      _togglePlayPause();
      return;
    }

    // Stop current playback and reset position
    await player.stop();
    setState(() {
      _selectedTrackIndex = index;
      isPlaying = true;
      position = Duration.zero;
      duration = Duration.zero;
    });

    // Set and play new track
    final selectedTrackPath = _tracks[index]['path']!;
    await player.setSource(AssetSource(selectedTrackPath));
    await player.resume();
  }

  void _togglePlayPause() async {
    if (_selectedTrackIndex == null)
      return; // Cannot play if no track is selected

    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
    setState(() => isPlaying = !isPlaying);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Meditation',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Choose a track:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _tracks.length,
                itemBuilder: (context, index) {
                  return _buildTrackCard(index);
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedTrackIndex != null)
              Column(
                children: [
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await player.seek(newPosition);
                      if (isPlaying) await player.resume();
                    },
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position)),
                        Text(_formatDuration(duration)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _togglePlayPause,
                    iconSize: 80,
                    color: AppTheme.primaryColor,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(int index) {
    final track = _tracks[index];
    final isSelected = _selectedTrackIndex == index;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _selectTrack(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.music_note : Icons.music_note_outlined,
                color: isSelected ? AppTheme.primaryColor : AppTheme.darkGray,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.darkGray,
                      ),
                    ),
                    Text(
                      track['artist']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
