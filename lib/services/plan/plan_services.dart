import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_journal/models/note_model.dart';
import 'package:travel_journal/models/plan.dart';
import 'package:travel_journal/services/notes/note_services.dart';

class PlanServices {
  Note? note;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  NoteServices noteServices = NoteServices();

  PlanServices({required this.note});

  Future<bool> createPlanInPlansCollection(Plan plan) async {
    try {
      await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note?.noteId)
          .collection('Plan')
          .add({
        'noteId': note!.noteId,
        'title': plan.title,
        'planDescription': plan.planDescription,
        'planLocations': plan.planLocations,
        'date': Timestamp.now(),
        'colorId': note!.colorId
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Plan>> getPlanInsideTheNote() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Plan')
          .where('noteId', isEqualTo: note!.noteId)
          .get();

      List<Plan> journey = querySnapshot.docs
          .map((doc) => Plan(
                noteId: doc['noteId'],
                date: doc['date'],
                colorId: doc['colorId'],
                planDescription: doc['planDescription'],
                planLocations: doc['planLocations'],
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

  //update plan
  Future<bool> updatePlanInPlansCollection(
      {required String title,
      required String description,
      required String locations}) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Plan')
          .where('noteId', isEqualTo: note!.noteId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Update the title of the first matching document
        querySnapshot.docs.first.reference.update({
          'title': title,
          'planDescription': description,
          'planLocations': locations
        });
        print('Plan updated successfully!');
      } else {
        print('No Plan found with the provided noteId.');
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //delete plan
  Future<bool> deletePlanInPlansCollection() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .doc(_auth.currentUser!.uid)
          .collection('Notes')
          .doc(note!.noteId)
          .collection('Plan')
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
  Future<int> addOrUpdatePlanInsideTheNote(
      {required String title,
      required String description,
      required String locations}) async {
    try {
      List<Plan>? plan = await getPlanInsideTheNote();
      if (plan != null && plan.isNotEmpty) {
        print("update triggered");
        await updatePlanInPlansCollection(
            title: title, description: description, locations: locations);
        return 1;
      } else {
        await createPlanInPlansCollection(Plan(
          title: title,
          planDescription: description,
          planLocations: locations,
          noteId: note!.noteId,
          colorId: note!.colorId,
          date: note!.date,
        ));
        return 2;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}