import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as md;

import '../../controllers/note_controller.dart';
import '../../models/note.dart';

class NoteEditForm extends GetView<NoteController> {
  const NoteEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    final NoteController controller = Get.find<NoteController>();

    return Form(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: controller.titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(
                color: Colors.grey, // Label color
                fontSize: 18.0, // Label font size
                fontWeight: FontWeight.bold, // Label font weight
              ),
              border: InputBorder.none, // Remove border
              contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Padding
            ),
            style: TextStyle(
              color: Colors.grey, // Text color
              fontSize: 22.0, // Text font size
            ),
          ),

          const SizedBox(height: 16.0),
          // TextFormField(
          //   controller: controller.contentController,
          //   decoration: InputDecoration(labelText: 'Content'),
          //   maxLines: 10,
          // ),
          Expanded(
            // height: 60,
            // width: Get.width,
            child: md.QuillEditor.basic(
              configurations: md.QuillEditorConfigurations(
                controller: controller.quillController,
              ),
            ),
          ),

          const SizedBox(height: 16.0),
          // ElevatedButton(
          //   onPressed: () {
          //     print("this is the content of note : ${controller.quillController.document.toDelta().toJson()}");
          //     final newNote = Note(
          //       title: controller.titleController.text,
          //       content: controller.quillController.document.toDelta().toJson().toString(),
          //     );
          //     if (controller.note == null) {
          //       controller.saveNote(newNote);
          //     } else {
          //       controller.editNote(newNote);
          //     }
          //     // Get.back();
          //   },
          //   child: Text(controller.note == null ? 'Create' : 'Update'),
          // ),
        ],
      ),
    );
  }
}
