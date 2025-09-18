import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Breathing guide state
  late AnimationController _breathingController;
  Timer? _breathingTimer;
  bool _isBreathing = false;
  String _breathingInstruction = "Breathe in";
  int _countdown = 4;

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
        _breathingTimer?.cancel();
        _breathingController.stop();
        _isBreathing = false;
        _countdown = 4;
      });
    });

    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
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
    _breathingController.dispose();
    _breathingTimer?.cancel();
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
    if (_selectedTrackIndex == null) return; // Cannot play if no track is selected

    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _startBreathingGuide() async {
    // Start audio if not already playing
    if (!isPlaying && _selectedTrackIndex != null) {
      await player.resume();
      setState(() => isPlaying = true);
    }

    setState(() {
      _isBreathing = true;
      _breathingInstruction = "Breathe in";
      _countdown = 4;
    });

    _breathingController.repeat(reverse: true);
    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_countdown > 1) {
            _countdown--;
          } else {
            _countdown = 4;
            _breathingInstruction = _breathingInstruction == "Breathe in" ? "Breathe out" : "Breathe in";
          }
        });
      }
    });
  }

  void _stopBreathingGuide() async {
    _breathingTimer?.cancel();
    _breathingController.stop();
    await player.pause();
    setState(() {
      _isBreathing = false;
      _countdown = 4;
      _breathingInstruction = "Breathe in";
      isPlaying = false;
    });
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
            if (_isBreathing) _buildBreathingGuide(),
            if (!_isBreathing) ...[
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
                _buildAudioControls(),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBreathing ? _stopBreathingGuide : _startBreathingGuide,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isBreathing ? Colors.red : AppTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                _isBreathing ? 'Stop Breathing Guide' : 'Start Breathing Guide',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
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

  Widget _buildAudioControls() {
    return Column(
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
    );
  }
  
  Widget _buildBreathingGuide() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _breathingInstruction,
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: AppTheme.darkGray),
            ),
            const SizedBox(height: 50),
            AnimatedBuilder(
              animation: _breathingController,
              builder: (context, child) {
                // Determine the size of the circle based on the animation value.
                final size = 150 + 100 * _breathingController.value;
                return Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _countdown.toString(), // Show the countdown inside the circle
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
