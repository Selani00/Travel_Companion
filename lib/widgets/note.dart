import 'package:flutter/material.dart';
import 'package:travel_journal/config/app_colors.dart';
import 'package:travel_journal/models/note_model.dart';
import 'package:travel_journal/services/notes/note_services.dart';

Widget noteCard(Function()? onTap, Note note) {
  print("Note Details: $note");
  int? colorId =
      int.tryParse(note.colorId.toString() ?? ''); // Convert string to int

  Color selectedColor =
      colorId != null && colorId >= 0 && colorId < AppColors.cardsColors.length
          ? AppColors.cardsColors[colorId]
          : Colors.grey; // Default color if index is invalid

  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: selectedColor,
            ),
            width: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Container(
                  height: 1,
                  width: double.infinity * 0.8,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Created Date:${note.date.toLocal().day}/${note.date.toLocal().month}/${note.date.toLocal().year} Created Time:${note.date.toLocal().hour}:${note.date.toLocal().minute}',
                        style: TextStyle(
                            color: Color(0xF7373535),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NoteServices().deleteOneNote(note.noteId);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
