import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class JournalStorage {
  static const String _journalKey = 'journalEntries';

  // This is a simple list to hold the entries in memory.
  // In a real app, you would load this from storage.
  // For this example, we will manage the list directly
  // with the add and update methods.
  static List<Map<String, dynamic>> entries = [];

  static Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesString = prefs.getString(_journalKey);
    if (entriesString != null) {
      final List<dynamic> decodedList = json.decode(entriesString);
      entries = decodedList.cast<Map<String, dynamic>>();
    }
  }

  static Future<void> addEntry(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    entries.add(entry);
    await prefs.setString(_journalKey, json.encode(entries));
  }

  static Future<void> updateEntry(
      int index, Map<String, dynamic> updatedEntry) async {
    final prefs = await SharedPreferences.getInstance();
    if (index >= 0 && index < entries.length) {
      entries[index] = updatedEntry;
      await prefs.setString(_journalKey, json.encode(entries));
    }
  }

  static Future<void> deleteEntry(int index) async {
    final prefs = await SharedPreferences.getInstance();
    if (index >= 0 && index < entries.length) {
      entries.removeAt(index);
      await prefs.setString(_journalKey, json.encode(entries));
    }
  }
}
