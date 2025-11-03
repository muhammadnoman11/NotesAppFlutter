import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes_app_flutter/models/note_model.dart';

import '../db/DatabaseHelper.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({super.key, this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      final doc = Document.fromJson(jsonDecode(widget.note!.contentJson));
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final delta = _quillController.document.toDelta();
    final contentJson = jsonEncode(delta.toJson());
    final now = DateTime.now().toIso8601String();

    final note = Note(
      id: widget.note?.id,
      title: 'Untitled',
      contentJson: contentJson,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(note);
    } else {
      await DatabaseHelper.instance.updateNote(note);
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note saved successfully')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      //   actions: [
      //     IconButton(icon: const Icon(Icons.save), onPressed: _saveNote),
      //   ],
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30), // Set the desired height
        child: AppBar(
          title: Text(
            style: TextStyle(fontSize: 18.0),
            widget.note == null ? 'Add Note' : 'Edit Note',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save, size: 20.0),
              onPressed: _saveNote,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          QuillSimpleToolbar(
            controller: _quillController,
            config: QuillSimpleToolbarConfig(
              showBackgroundColorButton: true,
              showColorButton: true,
              showAlignmentButtons: true,
              showInlineCode: false,
              showSubscript: false,
              showSuperscript: false,
              showCodeBlock: false,
              showIndent: false,
              showQuote: false,
              showListCheck: false,
              showHeaderStyle: false,
              showSearchButton: false,
              showLink: false,
            ),
          ),

          // Editor
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: QuillEditor.basic(
                controller: _quillController,
                config: QuillEditorConfig(
                  expands: true,
                  placeholder: 'Start writing your note...',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
