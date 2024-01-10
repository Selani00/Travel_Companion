import 'package:hive/hive.dart';
import 'package:travel_journal/models/note_images.dart';

class ImageServices{
  
  Future<void> saveImages(List<String> imagesList, String noteId) async {
  final box = await Hive.openBox<NoteImages>('notes_images');
  await box.put(noteId, NoteImages()..noteId = noteId..imagePaths = imagesList);
}

Future<List<String>> loadImages(String noteId) async {
  final box = await Hive.openBox<NoteImages>('notes_images');
  final NoteImages? noteImages = box.get(noteId);
  return noteImages?.imagePaths ?? [];
}

}