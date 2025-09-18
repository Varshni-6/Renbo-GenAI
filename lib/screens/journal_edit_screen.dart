import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import '../services/journal_storage.dart';
import 'package:path_provider/path_provider.dart';

class JournalEditScreen extends StatefulWidget {
  final Map<String, dynamic> entry;
  final int index;
  const JournalEditScreen({Key? key, required this.entry, required this.index})
      : super(key: key);

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  late TextEditingController _controller;
  File? pickedImage;
  String? recordedAudioPath;
  bool isRecording = false;
  final _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry['content']);
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedContent = _controller.text.trim();
    if (updatedContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content cannot be empty.')),
      );
      return;
    }

    final updatedEntry = Map<String, dynamic>.from(widget.entry);
    updatedEntry['content'] = updatedContent;
    updatedEntry['imagePath'] = pickedImage?.path ?? updatedEntry['imagePath'];
    updatedEntry['audioPath'] = recordedAudioPath ?? updatedEntry['audioPath'];

    JournalStorage.updateEntry(widget.index, updatedEntry);
    Navigator.of(context).pop();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  Future<void> _startStopRecording() async {
    if (isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        isRecording = false;
        if (path != null) {
          recordedAudioPath = path;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio recording stopped and saved.')),
      );
    } else {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path = '${tempDir.path}/${DateTime.now().toIso8601String()}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );
        setState(() {
          isRecording = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Recording started...')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permission to record audio not granted.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: const Text("Edit Journal Entry",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const Text(
              "Edit your thoughts:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color(0xFF064232),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Edit your entry here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (pickedImage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Image.file(
                  pickedImage!,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            if (recordedAudioPath != null)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Audio recorded.',
                    style: TextStyle(color: Colors.green)),
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _startStopRecording,
                  icon: Icon(isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white),
                  label: Text(isRecording ? 'Stop Recording' : 'Voice Journal',
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isRecording ? Colors.red : const Color(0xFF568F87),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: const Text('Add Image',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF568F87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF568F87),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _saveChanges,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
