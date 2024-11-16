// note.dart

import 'dart:convert';

class Note {
  String id;
  String title;
  String content;

  Note({
    required this.id,
    required this.title,
    this.content = '',
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
  };
}

// Модель для создания новой заметки
class NoteCreate {
  String title;
  String? content;

  NoteCreate({
    required this.title,
    this.content,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content ?? '',
  };
}
