import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/image/toolbar/image_button.dart';
import 'package:flutter_quill_extensions/embeds/others/camera_button/camera_button.dart';
import 'package:flutter_quill_extensions/embeds/video/toolbar/video_button.dart';
import 'package:get/get.dart';

import '../../controllers/note_controller.dart';

class QuillBarWidget extends GetView<NoteController> {
  const QuillBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GetBuilder<NoteController>(
      builder: (controller) {
        return QuillToolbar(
          configurations: const QuillToolbarConfigurations(),
          child: SizedBox(
            width: Get.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              // width:Get.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    // onPressed: () {},
                    onPressed: () {
                      controller.toggleToolbar();
                    },
                    icon: const Icon(
                      Icons.width_normal,
                      // color: Colors.red,
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    // Animation duration
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: controller.isShowToolbar == true
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Wrap(children: [
                              QuillToolbarHistoryButton(
                                isUndo: true,
                                controller: controller.quillController,
                              ),
                              QuillToolbarHistoryButton(
                                isUndo: false,
                                controller: controller.quillController,
                              ),
                              QuillToolbarToggleStyleButton(
                                options:
                                    const QuillToolbarToggleStyleButtonOptions(),
                                controller: controller.quillController,
                                attribute: Attribute.bold,
                              ),
                              QuillToolbarToggleStyleButton(
                                options:
                                    const QuillToolbarToggleStyleButtonOptions(),
                                controller: controller.quillController,
                                attribute: Attribute.italic,
                              ),
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.underline,
                              ),
                              QuillToolbarClearFormatButton(
                                controller: controller.quillController,
                              ),
                              const VerticalDivider(),
                              QuillToolbarImageButton(
                                controller: controller.quillController,
                              ),
                              QuillToolbarCameraButton(
                                controller: controller.quillController,
                              ),
                              QuillToolbarVideoButton(
                                controller: controller.quillController,
                              ),
                              const VerticalDivider(),
                              QuillToolbarColorButton(
                                controller: controller.quillController,
                                isBackground: false,
                              ),
                              QuillToolbarColorButton(
                                controller: controller.quillController,
                                isBackground: true,
                              ),
                              const VerticalDivider(),
                              QuillToolbarSelectHeaderStyleDropdownButton(
                                controller: controller.quillController,
                              ),
                              const VerticalDivider(),
                              QuillToolbarToggleCheckListButton(
                                controller: controller.quillController,
                              ),
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.ol,
                              ),
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.ul,
                              ),
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.inlineCode,
                              ),
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.blockQuote,
                              ),
                              QuillToolbarIndentButton(
                                controller: controller.quillController,
                                isIncrease: true,
                              ),
                              QuillToolbarIndentButton(
                                controller: controller.quillController,
                                isIncrease: false,
                              ),
                              const VerticalDivider(),
                              QuillToolbarLinkStyleButton(
                                  controller: controller.quillController),
                            ]),
                          )
                        : Container(),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
