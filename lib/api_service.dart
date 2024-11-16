// api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'note.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8000";

  // Получение всех заметок
  Future<List<Note>> fetchNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes/'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((noteJson) => Note.fromJson(noteJson)).toList();
    } else {
      throw Exception('Failed to load notes: ${response.body}');
    }
  }

  // Создание новой заметки
  Future<Note> createNote(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/notes/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(NoteCreate(title: title).toJson()), // Используем NoteCreate
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create note: ${response.body}');
    }
  }

  // Обновление заметки
  Future<Note> updateNote(Note note) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notes/${note.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode == 200) {
      return Note.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update note: ${response.body}');
    }
  }

  // Удаление заметки
  Future<void> deleteNote(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/notes/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete note: ${response.body}');
    }
  }
}

