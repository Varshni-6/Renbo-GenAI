import 'package:flutter/material.dart';

class JournalDetailScreen extends StatelessWidget {
  final Map<String, String> entry;
  const JournalDetailScreen({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emotion = entry['emotion'] ?? '';
    final content = entry['content'] ?? '';
    final dateStr = entry['date'] ?? '';
    String formattedDate = '';
    try {
      final dt = DateTime.parse(dateStr);
      formattedDate =
          '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {}

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: Text('Entry — $emotion',
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (formattedDate.isNotEmpty)
              Text(formattedDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
