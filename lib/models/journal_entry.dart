import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 0)
class JournalEntry extends HiveObject {
  @HiveField(0)
  late String content;

  @HiveField(1)
  late DateTime timestamp;

  @HiveField(2)
  late String? mood;

  @HiveField(3)
  late String? attachmentPath;
}
