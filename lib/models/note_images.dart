import 'package:hive/hive.dart';

class NoteImages {
  late String noteId;
  late List<String> imagePaths;
}

void registerHiveAdapters() {
  Hive.registerAdapter(NoteImagesAdapter());
}

class NoteImagesAdapter extends TypeAdapter<NoteImages> {
  @override
  final typeId = 0;

  @override
  NoteImages read(BinaryReader reader) {
    return NoteImages()
      ..noteId = reader.read()
      ..imagePaths = reader.readList().cast<String>();
  }

  @override
  void write(BinaryWriter writer, NoteImages obj) {
    writer.write(obj.noteId);
    writer.writeList(obj.imagePaths);
  }
}
