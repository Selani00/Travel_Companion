import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_journal/models/note_images.dart';

class HiveServices {
  final String _boxName = "ImagesBox";

  Future<Box<NoteImages>> get _box async =>
      await Hive.openBox<NoteImages>(_boxName);

  Future<void> addItem(NoteImages noteImagePair) async {
    var box = await _box;
    await box.add(noteImagePair);
  }

  Future<List<NoteImages>> getAllPairs() async {
    var box = await _box;
    return box.values.toList();
  }

  //get one notimage using noteId
  Future<NoteImages?> getOnePair(String id) async {
    var box = await _box;
    // Find the first NoteImages object where the noteId matches
    var noteImages = box.values.firstWhere(
      (element) => element.noteId == id,
    );
    return noteImages;
  }

  Future<void> deletePairs(int index) async {
    var box = await _box;
    await box.deleteAt(index);
  }
}
