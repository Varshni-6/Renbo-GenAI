class JournalStorage {
  // newest entries at index 0
  static final List<Map<String, String>> entries = [];

  static void addEntry(Map<String, String> entry) {
    entries.insert(0, entry);
  }

  static void clear() => entries.clear();
}
