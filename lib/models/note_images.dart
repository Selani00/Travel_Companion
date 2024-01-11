import 'package:hive_flutter/hive_flutter.dart';

part 'note_images.g.dart';

@HiveType(typeId: 1)
class NoteImages {
  @HiveField(0)
  final String noteId;
  @HiveField(1)
  final List<String> imagePaths;

  NoteImages(this.noteId, this.imagePaths);
}
