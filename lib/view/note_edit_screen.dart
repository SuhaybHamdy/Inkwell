import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/view/widget/my_quill_toolbar.dart';
import '../controllers/note_controller.dart';
import '../models/note.dart';
import 'components/note_edit_form.dart';

class NoteEditScreen extends GetResponsiveView<NoteController> {
  final Note? note;

  NoteEditScreen({super.key, this.note});

  @override
  Widget? desktop() {
    return Scaffold(

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.grey[200],
                    child: const Center(
                        child: Text('Sidebar or additional features here')),
                  ),
                ),
                const Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: NoteEditForm(),
                  ),
                ),
              ],
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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: NoteEditForm(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget? phone() {
    return GetBuilder<NoteController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(note == null ? 'Create Note' : 'Edit Note'),
            actions: [
              IconButton(
              onPressed: () async {
                print("this is the content of note : ${controller.quillController.document.toDelta().toJson()}");

                final json = jsonEncode(controller.quillController.document.toDelta().toJson());

                final newNote = Note(
                  id:DateTime.now().microsecondsSinceEpoch.toString(),
                  title: controller.titleController.text,
                  content: json,
                );

                print('this is the value of the delta : ${newNote.content}');
                if (controller.note == null) {
                await   controller.saveNote(newNote);
                } else {
                  controller.editNote(newNote);
                }
                controller.note=Note(title: '', content: '');
                controller.titleController.text='';
                controller.quillController.clear();
                controller.update();
                Get.back();
              },
              icon: Icon( Icons.check  ),)
            ],
          ),
          body: Stack(
            children: [

              Padding(
                  padding: EdgeInsets.all(16.0), child: NoteEditForm()),
              Container(
                alignment: Alignment.topCenter,
                // color: Colors.red,
                height: 60,
                width: Get.width,
                child: const QuillBarWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}
