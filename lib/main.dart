import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'providers/mood_provider.dart';
import 'models/journal_entry.dart';
import 'package:flutter/services.dart';
import 'screens/emotion_tracker.dart';
import 'screens/journal_entries.dart';
import 'screens/journal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Load the .env file before running the app
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(JournalEntryAdapter());
  await Hive.openBox<JournalEntry>('journalEntries');

  runApp(
    ChangeNotifierProvider(
      create: (context) => MoodProvider(),
      child: const RenboApp(),
    ),
  );
}
