import 'package:flutter/material.dart';
import '../services/journal_storage.dart';
import 'journal_detail.dart';
import 'journal_edit_screen.dart'; // Correct import for the new class

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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JournalEditScreen(
                                    entry: entry, index: index),
                              ),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              size: 20, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Entry'),
                                    content: const Text(
                                        'Are you sure you want to delete this entry?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ) ??
                                false;

                            if (confirmed) {
                              await JournalStorage.deleteEntry(index);
                              setState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => JournalDetailScreen(
                                  entry: entry.map((key, value) =>
                                      MapEntry(key, value?.toString() ?? "")),
                                )),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
