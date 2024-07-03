import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/add_or_edit_note_controller.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/view/components/note_edit_form.dart';
import 'package:inkwell/view/widget/my_quill_toolbar.dart';

class NoteEditScreen extends GetResponsiveView<AddOrEditNoteController> {
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
                      child: Text('Sidebar or additional features here'),
                    ),
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
        padding: EdgeInsets.all(0.0),
        child: NoteEditForm(),
      ),
    );
  }

  @override
  Widget? phone() {
    return GetBuilder<AddOrEditNoteController>(
      builder: (controller) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(note == null ? 'Create Note' : 'Edit Note'),
          //   actions: [
          //     IconButton(
          //       onPressed: () async {
          //         await controller.saveOrUpdateNote();
          //       },
          //       icon: const Icon(Icons.check),
          //     )
          //   ],
          // ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () => controller.saveOrUpdateNote(),
          //   child: Icon(Icons.save),
          // ),
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              const Padding(
                padding: EdgeInsets.all(0.0),
                child: NoteEditForm(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // alignment: Alignment.bottomCenter,
                    // height: 60,
                    color:
                        Get.theme.colorScheme.onSurface,
                    width: Get.width,
                    child: controller.expanded.isTrue
                        ? Container(
                            height: 70,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_back)),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.save)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.image_outlined)),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.join_full)),
                              ],
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    // alignment: Alignment.bottomCenter,
                    // height: 60,
                    color:
                        Get.theme.colorScheme.secondaryContainer,
                    width: Get.width,
                    child: controller.expanded.isTrue
                        ? const QuillBarWidget()
                        : Container(),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
