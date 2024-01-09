import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_journal/models/journey.dart';
import 'package:travel_journal/models/note_model.dart';
import 'package:travel_journal/services/notes/note_services.dart';

class JourneyServices {
  Note? note;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NoteServices noteServices = NoteServices();

  //constructor
  JourneyServices({this.note});

  //creation
  Future<bool> createJourneyInJourneyCollection(Journey journey) async {
    try {
      String noteId = await noteServices.createNoteInNotesCollection();
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(noteId)
          .collection('Journey')
          .add({
        'noteId': note!.noteId,
        'title': journey.title,
        'journeyDescription': journey.journeyDescription,
        'journeyLocations': journey.journeyLocations,
        'date': Timestamp.now(),
      });
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .update({
        'title': journey.title,
      });
      print("Note added");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Journey>> getJourneyInsideTheNote() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Journey')
          .where('noteId', isEqualTo: note!.noteId)
          .get();

      List<Journey> journey = querySnapshot.docs
          .map((doc) => Journey(
                noteId: doc['noteId'],
                date: doc['date'],
                colorId: doc['colorId'],
                journeyDescription: doc['journeyDescription'],
                journeyLocations: doc['journeyLocations'],
                title: doc['title'],
              ))
          .toList();
      print(journey);
      return journey;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //update data
  Future<bool> updateJourneyInsideTheNote(
      {required String title,
      required String description,
      required String locations}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Journey')
          .where('noteId', isEqualTo: note!.noteId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // Update the title of the first matching document
        querySnapshot.docs.first.reference.update({
          'title': title,
          'journeyDescription': description,
          'journeyLocations': locations
        });
        print('Journey updated successfully!');
      } else {
        print('No Journey found with the provided noteId.');
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //delete journey
  Future<bool> deleteJourneyInsideTheNote() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Journey')
          .where('noteId', isEqualTo: note!.noteId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the title of the first matching document
        querySnapshot.docs.first.reference.delete();
        print('Journey deleted successfully!');
      } else {
        print('No Journey found with the provided noteId.');
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //add or update function
  // Future<bool> addOrUpdateJourneyInsideTheNote(
  //     {required String title,
  //     required String description,
  //     required String locations}) async {
  //   try {
  //     List<Journey>? journey = await getJourneyInsideTheNote();
  //     if (journey != null && journey.isNotEmpty) {
  //       print("update triggered");
  //       return await updateJourneyInsideTheNote(
  //           title: title, description: description, locations: locations);
  //     } else {
  //       return await createJourneyInJourneyCollection(Journey(
  //         title: title,
  //         journeyDescription: description,
  //         journeyLocations: locations,
  //         noteId: note!.noteId,
  //         colorId: note!.colorId,
  //         date: note!.date,
  //       ));
  //     }
  //   } catch (e) {
  //     print(e);
  //     return false;
  //   }
  // }
}
