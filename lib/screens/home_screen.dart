import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/utils/constants.dart';
import 'package:renbo/screens/chat_screen.dart';
import 'package:renbo/screens/meditation_screen.dart';
import 'package:renbo/screens/sessions_screen.dart';
import 'package:renbo/screens/emotion_tracker.dart'; // Correct import for the emotion tracker screen
import 'package:renbo/screens/hotlines_screen.dart'; // ✅ Import your new hotlines screen
import 'package:renbo/widgets/mood_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Afternoon, ${AppConstants.initialUsername}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 16),
              const MoodCard(
                title: 'Thought of the day',
                content: AppConstants.thoughtOfTheDay,
                image: 'assets/lottie/axolotl.json',
              ),
              const SizedBox(height: 16),
              _buildMainButtons(context),
              const SizedBox(height: 16),
              _buildWellnessPond(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildButton(
              context,
              icon: Icons.edit_note,
              label: 'Journal',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmotionTrackerScreen()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.chat_bubble_outline,
              label: 'Chat with Ren',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
            ),
            const SizedBox(width: 16),
            _buildButton(
              context,
              icon: Icons.headphones_outlined,
              label: 'Meditation',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeditationScreen()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ✅ New Row for Hotlines button
        Row(
          children: [
            _buildButton(
              context,
              icon: Icons.phone_in_talk,
              label: 'Hotlines',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => HotlinesScreen()),
              ),
            ),
            // If you want, you can leave space for future buttons
            const SizedBox(width: 16),
            Expanded(child: Container()), // keeps layout aligned
          ],
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: AppTheme.primaryColor),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWellnessPond() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.secondaryColor),
      ),
      child: const Row(
        children: [
          Icon(Icons.spa, size: 40, color: AppTheme.secondaryColor),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Pond',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                Text(
                  'You\'re not alone! See what others are doing.',
                  style: TextStyle(color: AppTheme.darkGray),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
