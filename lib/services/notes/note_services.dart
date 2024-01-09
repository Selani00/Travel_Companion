import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_journal/components/app_colors.dart';
import 'package:travel_journal/models/note_model.dart';

class NoteServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int color_id = Random().nextInt(AppColors.cardsColors.length);

  Future<String> createNoteInNotesCollection() async {
    try {
      DocumentReference docRef = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .add({
        'noteId': '',
        'title': 'New Note',
        'date': DateTime.now(),
        'colorId': color_id.toString(),
      });
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(docRef.id)
          .update({'noteId': docRef.id});
      print("Note added");
      return docRef.id;
    } catch (e) {
      print(e);
      return "false";
    }
  }

  //get current id of the note

  //
  Future<List<Note>> getAllNotes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .orderBy('date', descending: true)
          .get();

      List<Note> notes = querySnapshot.docs
          .map((doc) => Note(
                noteId: doc['noteId'],
                date: (doc['date'] as Timestamp).toDate(),
                title: doc['title'],
                colorId: doc['colorId'],
              ))
          .toList();
      print(notes);
      return notes;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
