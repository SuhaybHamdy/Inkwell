import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';

class NoteEditScreen extends GetResponsiveView<NoteController> {
  final Note? note;

  NoteEditScreen({this.note});

  @override
  Widget? desktop() {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Create Note' : 'Edit Note'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[200],
              child: Center(child: Text('Sidebar or additional features here')),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: NoteEditForm(note: note),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget? tablet() {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: NoteEditForm(note: note),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? phone() {
    return Scaffold(
      appBar: AppBar(
        title: Text(note == null ? 'Create Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NoteEditForm(note: note),
      ),
    );
  }
}

class NoteEditForm extends StatelessWidget {
  final Note? note;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  NoteEditForm({Key? key, this.note}) : super(key: key) {
    if (note != null) {
      _titleController.text = note!.title;
      _contentController.text = note!.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find<NoteController>();

    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          SizedBox(height: 16.0),
          TextFormField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
            maxLines: 10,
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // final newNote = Note(
              //   id: note?.id ?? UniqueKey().toString(),
              //   title: _titleController.text,
              //   content: _contentController.text,
              // );
              // if (note == null) {
              //   controller.saveNote(newNote);
              // } else {
              //   controller.editNote(newNote);
              // }
              // Get.back();
            },
            child: Text(note == null ? 'Create' : 'Update'),
          ),
        ],
      ),
    );
  }
}
