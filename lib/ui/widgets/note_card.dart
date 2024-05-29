// TODO Implement this library.

// lib/ui/widgets/note_card.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/note_controller.dart';

import '../../models/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function() onTap;
  final Function(Note) onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  QuillController quillController = QuillController.basic();

  Future<void> _initializeQuillControllerWithNoteContent(
      Note? noteValue) async {
    try {
      final deltaJson = jsonDecode(noteValue!.content) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);

      quillController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeQuillControllerWithNoteContent(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find();
    // quillController =
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        color: Get.theme.colorScheme.inversePrimary,
        margin: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () => widget.onDelete(widget.note),
                  child: Icon(
                    Icons.delete,
                    color: Get.theme.colorScheme.error,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.note.title.toString(),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Container(
                    child: Text(
                      controller.extractPlainTextFromNoteContent(widget.note)
                      // widget.note.content.toString()
                      ,
                      // Truncate content
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
