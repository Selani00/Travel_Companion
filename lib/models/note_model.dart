class Note {
  String noteId;
  String title;
  String date;
  String colorId;

  Note({
    required this.noteId,
    required this.title,
    required this.date,
    required this.colorId,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      colorId: json['colorId'] ?? 0,
      noteId: '',
    );
  }
}
