import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

import '../models/note_model.dart';
import '../screens/note_screen.dart';



class NoteCard extends StatelessWidget {
  final Note note;
  final Function(int) deleteNote;
  final VoidCallback loadNotes;

  const NoteCard({
    Key? key,
    required this.note,
    required this.deleteNote,
    required this.loadNotes,
  }) : super(key: key);

  // Extract plain text from Quill content JSON
  String _extractPlainText(String contentJson) {
    try {
      final doc = Document.fromJson(jsonDecode(contentJson));
      final text = doc.toPlainText().trim();
      return text.isNotEmpty ? text : 'Empty note';
    } catch (e) {
      return contentJson.trim().isNotEmpty ? contentJson : 'Empty note';
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = DateTime.parse(note.createdAt);
    final noteText = _extractPlainText(note.contentJson);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoteScreen(note: note),
              ),
            );
            loadNotes();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // date badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E').format(date).toUpperCase(), // MON
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      DateFormat('d').format(date), // 3
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      noteText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('hh:mm a').format(date),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'delete'){
                    deleteNote(note.id!);
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NoteScreen(note: note)),
                    ).then((_) => loadNotes());
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
