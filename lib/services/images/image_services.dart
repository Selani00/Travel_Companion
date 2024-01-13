import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';


class ImageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<String>> uploadImages(List<XFile> xFiles, String noteId) async {
    List<String> downloadURLs = [];

    try {
      for (var xFile in xFiles) {
        File file = File(xFile.path);
        var timeStamp = DateTime.now().millisecondsSinceEpoch;
        var imageName = '$noteId$timeStamp.jpg';

        TaskSnapshot snapshot = await _storage
            .ref('note_images/$noteId/$imageName')
            .putFile(file);

        String imageUrl = await snapshot.ref.getDownloadURL();
        downloadURLs.add(imageUrl);
      }

      return downloadURLs;
    } catch (e) {
      print('Error uploading images: $e');
      return [];
    }
  }

  Future<List<String>> getImageUrls(String noteId) async {
    List<String> downloadURLs = [];

    try {
      ListResult result = await _storage.ref('note_images/$noteId').list();
      for (var imageRef in result.items) {
        String imageUrl = await imageRef.getDownloadURL();
        downloadURLs.add(imageUrl);
      }

      return downloadURLs;
    } catch (e) {
      print('Error retrieving images: $e');
      return [];
    }
  }
}
