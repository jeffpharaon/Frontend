// note_detail_screen.dart

import 'package:flutter/material.dart';
import 'note.dart';
import 'api_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final ApiService apiService;

  NoteDetailScreen({required this.note, required this.apiService});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _contentController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
  }

  Future<void> _saveNote() async {
    setState(() {
      isSaving = true;
    });
    Note updatedNote = Note(
      id: widget.note.id,
      title: widget.note.title,
      content: _contentController.text,
    );
    try {
      await widget.apiService.updateNote(updatedNote);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении заметки')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note.title),
        actions: [
          IconButton(
            icon: isSaving
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
                : Icon(Icons.save),
            onPressed: isSaving ? null : _saveNote,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                widget.note.title.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: TextStyle(color: textColor, fontSize: 18),
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Введите заметку здесь...',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 16, 15, 15),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
