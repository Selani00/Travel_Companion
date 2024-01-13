import 'package:flutter/material.dart';

class Note {
  String noteId;
  String title;
  DateTime date;
  String colorId;
  List<Image>? images = [];

  Note({
    required this.noteId,
    required this.title,
    required this.date,
    required this.colorId,
    this.images,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      colorId: json['colorId'] ?? 0,
      noteId: '',
      images: [],
    );
  }
}
