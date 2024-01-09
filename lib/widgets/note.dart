import 'package:flutter/material.dart';
import 'package:travel_journal/config/app_colors.dart';
import 'package:travel_journal/models/note_model.dart';

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
      height: 100,
      width: 100,
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: selectedColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListView(
        children: [
          Text(
            note.title,
            style: AppColors.mainTitle,
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            '${note.date.toLocal()}',
            style: AppColors.dateTitle,
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    ),
  );
}
