

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/note_controller.dart';
import '../../../../models/note.dart';
import '../../../../routes/app_routes.dart';
import '../../../../ui/widgets/note_card.dart';

class NoteListView extends StatelessWidget {
  final List<Note> notes;
  final NotesController controller;

  NoteListView({required this.notes, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () {
            Get.toNamed(AppRoutes.noteDetail, arguments: note.id);
          },
          onDelete: (note) async {
            await controller.deleteNote(note);
          }, onEdit: (Note ) {  },
        );
      },
    );
  }
}
