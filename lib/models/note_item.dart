class NoteItem {
  final String id, title, dateText;
  final bool isCompleted;
  const NoteItem({
    required this.id,
    required this.title,
    required this.dateText,
    this.isCompleted = false,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateText': dateText,
    'isCompleted': isCompleted,
  };
  factory NoteItem.fromJson(Map<String, dynamic> json) => NoteItem(
    id: json['id'] is String ? json['id'] as String : '',
    title: json['title'] is String ? json['title'] as String : 'Untitled note',
    dateText: json['dateText'] is String
        ? json['dateText'] as String
        : 'Unknown date',
    isCompleted: json['isCompleted'] is bool
        ? json['isCompleted'] as bool
        : false,
  );
  NoteItem toggled() => NoteItem(
    id: id,
    title: title,
    dateText: dateText,
    isCompleted: !isCompleted,
  );
}
