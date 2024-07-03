import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as md;

import '../../../controllers/add_or_edit_note_controller.dart';
import '../../../localization/l10n.dart';
import '../my_quill_toolbar.dart';

Widget buildEditorCard(AddOrEditNoteController controller) {
  print(
      'this is the background card data : ${controller.currentNote?.background?.value}');

  return Obx(() {
    // Determine the text direction based on the app's locale or a specific condition
    // TextDirection textDirection = Get.locale?.languageCode == 'ar' // Assuming 'ar' for Arabic
    //     ? TextDirection.RTL
    //     : TextDirection.LTR;

    return Stack(
      children: [
        // Overlay widget

        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: controller.currentNote?.background?.value != null
                ? controller
                    .parseColor(controller.currentNote!.background!.value!)
                : Colors.transparent,
            image: controller.selectedImage.value != null
                ? DecorationImage(
                    image: AssetImage(controller.selectedImage.value!),
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          child: controller.currentNote?.background != null &&
                  controller.currentNote!.background!.type != 'color'
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                )
              : null,
        ),
        Container(
          padding: EdgeInsets.all(controller.expanded.isFalse ? 8.0 : 0.0),
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: controller.expanded.isTrue ? 80 : 0,
              ),
              TextField(
                controller: controller.titleController,
                // textDirection: textDirection, // Apply text direction
                decoration: InputDecoration(
                    hintText: L10n.addTitle.tr,
                    hintStyle: Get.textTheme.headlineLarge,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
                style: Get.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),

              // Body
              Expanded(
                child: md.QuillEditor.basic(
                  configurations: md.QuillEditorConfigurations(
                    controller: controller.quillController,
                    checkBoxReadOnly: true,
                  ),
                ),
              ),
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 400),
              //   child: controller.expanded.isTrue
              //       ? Column(
              //           mainAxisAlignment: MainAxisAlignment.end  ,
              //           children: [
              //             Container(
              //               alignment: Alignment.topCenter,
              //               height: 60,
              //               width: Get.width,
              //               child: const QuillBarWidget(),
              //             ),
              //           ],
              //         )
              //       : Container(),
              // ),
              Container(
                alignment: Alignment.topCenter,
                color: Colors.transparent,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.expanded.value = !controller.expanded.value;
                      controller.update();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: controller.expanded.isTrue
                            ? const Icon(
                                Icons.expand_less_outlined,
                                size: 40.0,
                              )
                            : const Icon(
                                Icons.expand_more_outlined,
                                size: 40.0,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // if (controller.isOverlayVisible.isFalse)
        //   Positioned(
        //     top: Get.height - 200,
        //     bottom: 100,
        //     left: 0,
        //     right: 0,
        //     child: GestureDetector(
        //       onTap: () => controller.toggleOverlay(),
        //       child: Container(
        //         color: Colors.red,
        //         child: Center(
        //           child: GestureDetector(
        //               onTap: () {}, // Prevents taps from propagating
        //               child: Container(
        //                 width: Get.width,
        //                 height: 40,
        //
        //                 child: Row(
        //                   children: [
        //                     Expanded(
        //                       flex: 3,
        //                       child: TextFormField(
        //                         controller: controller.contentController,
        //                         decoration: const InputDecoration(
        //                             hintText: 'Warning Prompt to the ai'),
        //                       ),
        //                     ),
        //                     Expanded(
        //                       flex: 1,
        //                       child: ElevatedButton(
        //                           onPressed: () =>
        //                               controller.generateContentUsingAI(),
        //                           child: Text('Suggest')),
        //                     )
        //                   ],
        //                 ),
        //               ) // Your overlay content
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  });
}
