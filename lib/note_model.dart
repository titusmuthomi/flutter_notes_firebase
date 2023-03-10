class Note {
  final String noteid;
  final String title;
  final String notes;
  final String date;

  Note(
      {required this.noteid,
      required this.title,
      required this.notes,
      required this.date});

  Map<String, dynamic> toJson() =>
      {'id': noteid, 'title': title, 'details': notes, 'date': date};

  static Note fromJson(Map<String, dynamic> json) => Note(
      noteid: json['id'],
      title: json['title'],
      notes: json['details'],
      date: json['date']);
}
