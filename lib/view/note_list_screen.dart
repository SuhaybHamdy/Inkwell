// lib/ui/screens/note_list_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/note_controller.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/routes/app_routes.dart';
import 'package:inkwell/ui/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class NoteListScreen extends StatelessWidget {
  final NoteController controller = Get.find<NoteController>();

  NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var notes = controller.notes;
    print('this is a note list length: ${notes.length}');
    return GetBuilder<NoteController>(
      builder: (controller) {
        return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Get.toNamed(AppRoutes.noteDetail),
              child: const Icon(Icons.note_add),
            ),
            body: Column(
              children: [
                // Container(
                //     height: 60,width: Get.width,
                //     alignment: Alignment.bottomCenter,
                //     margin: EdgeInsets.all(16),
                //     child: Row(
                //
                //       children: [
                //          Row(
                //            children: [
                //            //   IconButton(
                //            //   icon: Icon(Icons.arrow_back_ios),
                //            //   onPressed: () => Get.back(),
                //            // ),
                //              Text('Inkwell',style: Get.theme.textTheme.headlineSmall,),
                //            ],
                //          ),
                //     Spacer(),
                //     IconButton(
                //             icon: Icon(Icons.add),
                //             onPressed: () => Get.toNamed(AppRoutes.noteDetail),
                //           ),
                //       ],
                //     )),
                AppBar(
                  title: const Text('Inkwell'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        controller.titleController.text = '';
                        controller.quillController.clear();
                        Get.toNamed(AppRoutes.noteDetail);


                      },
                    ),
                  ],
                ),


                notes.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                  height: Get.height-100,width: Get.width,
                        child: MasonryGridView.builder(
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return NoteCard(
                            note: note,
                            onTap: () {
                              controller.titleController.text='';
                              controller.quillController.clear();
                              Get.toNamed(AppRoutes.noteDetail,
                                  arguments: note.id);
                              controller.initializeNote();
                              controller.update();
                            },
                            onDelete: (note) async {
                              print('deleting call');
                              await controller.deleteNote(note);
                            },
                          );
                        },
                      )

                        // GridView.builder(
                        //               itemCount: notes.length,
                        //               itemBuilder: (context, index) {
                        //                 final note = notes[index];
                        //                 return NoteCard(
                        //                   note: note,
                        //                   onTap: () {
                        //                     Get.toNamed(AppRoutes.noteDetail,
                        //                         arguments: note.id);
                        //                     controller.initializeNote();
                        //                     controller.update();
                        //                   },
                        //                   onDelete: (note) async {
                        //                     print('deleting call');
                        //                     await controller.deleteNote(note);
                        //                   },
                        //                 );
                        //               }, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                        //             ),
                        ),
              ],
            ));
      },
    );
  }
}
