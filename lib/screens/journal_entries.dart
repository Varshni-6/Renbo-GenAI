import 'package:flutter/material.dart';
import '../services/journal_storage.dart';
import 'journal_detail.dart';

class JournalEntriesScreen extends StatefulWidget {
  const JournalEntriesScreen({Key? key}) : super(key: key);

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen> {
  @override
  Widget build(BuildContext context) {
    final entries = JournalStorage.entries;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: const Text("My Journal Entries",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                "No entries yet. Write your first one!",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = entries[index];
                final preview = (entry['content'] ?? '').trim();
                final previewText = preview.isEmpty
                    ? "(empty)"
                    : (preview.length > 80
                        ? '${preview.substring(0, 80)}…'
                        : preview);
                final emotion = entry['emotion'] ?? 'Emotion';
                final dateStr = entry['date'] ?? '';

                DateTime? dt;
                String formattedDate = '';
                try {
                  dt = DateTime.parse(dateStr);
                  formattedDate =
                      '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                } catch (_) {}

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    title: Text(emotion,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(previewText),
                        if (formattedDate.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(formattedDate,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey)),
                        ]
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => JournalDetailScreen(entry: entry)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
