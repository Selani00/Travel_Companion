import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageServices {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future uploadImages(PlatformFile pickedFile, String noteId) async {
    List<String> downloadURLs = [];
    final path = '$noteId/${pickedFile.name}';
    UploadTask? uploadTask;

    try {
      // for (var xFile in xFiles) {
      //   File file = File(xFile.path);
      //   var timeStamp = DateTime.now().millisecondsSinceEpoch;
      //   var imageName = '$noteId$timeStamp.jpg';

      //   TaskSnapshot snapshot = await _storage
      //       .ref('note_images/$noteId/$imageName')
      //       .putFile(file);

      //   String imageUrl = await snapshot.ref.getDownloadURL();
      //   downloadURLs.add(imageUrl);
      final file = File(pickedFile!.path!);
      final ref = _storage.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      downloadURLs.add(urlDownload);
      print('Download URL: $urlDownload');
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
