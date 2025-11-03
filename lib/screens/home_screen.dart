import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_flutter/models/note_model.dart';

import '../db/DatabaseHelper.dart';
import '../widgets/note_card.dart';
import 'note_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await DatabaseHelper.instance.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  void deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);
    loadNotes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick Notes"),
        centerTitle: true,
      ),
      body: notes.isEmpty
          ? const Center(child: Text("No Notes Yet"))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteCard(
            note: note,
            deleteNote: deleteNote,
            loadNotes: loadNotes,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        child: const Icon(Icons.edit),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NoteScreen(),
            ),
          );
          loadNotes();
        },
      ),
    );
  }
}