//home_screen.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'note.dart';
import 'note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> items = [];
  List<Note> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  ApiService apiService = ApiService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filteredItems = items;
    searchController.addListener(_filterItems);
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    try {
      List<Note> notes = await apiService.fetchNotes();
      setState(() {
        items = notes;
        filteredItems = notes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при загрузке заметок')),
      );
    }
  }

  void _filterItems() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = items
          .where((note) => note.title.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _showInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите название'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Название"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  try {
                    Note newNote = await apiService.createNote(controller.text);
                    setState(() {
                      items.add(newNote);
                      _filterItems();
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка при создании заметки')),
                    );
                  }
                }
              },
              child: Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(Note note) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Удалить заметку'),
        content: Text('Вы уверены, что хотите удалить "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              confirm = true;
              Navigator.of(ctx).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm) {
      try {
        await apiService.deleteNote(note.id);
        setState(() {
          items.remove(note);
          _filterItems();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Заметка удалена')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении заметки')),
        );
      }
    }
  }

  Future<void> _navigateToDetail(Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(note: note, apiService: apiService),
      ),
    );
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    Color background = Color.fromARGB(255, 16, 15, 15);
    Color tileColor = Colors.black.withOpacity(0.5);
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Мои Заметки'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: tileColor,
                      hintText: 'Поиск...',
                      hintStyle: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SizedBox(height: 20),
                  filteredItems.isEmpty
                      ? Text(
                    'Нет заметок',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  )
                      : Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: filteredItems.map((note) {
                      return GestureDetector(
                        onTap: () => _navigateToDetail(note),
                        onLongPress: () => _deleteNote(note),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              note.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}