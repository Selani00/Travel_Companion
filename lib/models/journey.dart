import 'package:travel_journal/models/note_model.dart';

class Journey extends Note {
  String journeyDescription;
  String journeyLocations;
 

  Journey({
    required this.journeyDescription,
    required this.journeyLocations, required super.title,
     required super.date, required super.colorId, required super.noteId,
  });
}
