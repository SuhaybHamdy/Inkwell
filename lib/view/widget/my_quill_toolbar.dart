import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/image/toolbar/image_button.dart';
import 'package:flutter_quill_extensions/embeds/others/camera_button/camera_button.dart';
import 'package:flutter_quill_extensions/embeds/video/toolbar/video_button.dart';
import 'package:get/get.dart';

import '../../constant/image_url.dart';
import '../../controllers/add_or_edit_note_controller.dart';
import '../../controllers/note_controller.dart';

class QuillBarWidget extends GetView<AddOrEditNoteController> {
  const QuillBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return GetBuilder<AddOrEditNoteController>(
      builder: (controller) {
        ImagesURL imagesURL = ImagesURL();
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
                  // OverlayPortal(controller: controller, overlayChildBuilder: overlayChildBuilder),

                  IconButton(
                    onPressed: () {
                      controller.expanded.value=!controller.expanded.value;
                      controller.update();
                    },
                    icon: const Icon(Icons.expand_less_outlined),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.toggleOverlay();
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                  controller.suggestionsLoading.isTrue
                      ? Container(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Get.theme.colorScheme.primary,))
                      : GestureDetector(
                          onTap: () => controller.generateContentUsingAI(),
                          child: Container(
                              height: 30,
                              width: 30,
                              child: Image.asset(ImagesURL.aiImagePath)),
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
                              QuillToolbarToggleStyleButton(
                                controller: controller.quillController,
                                attribute: Attribute.rtl,
                              ),

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
                              QuillToolbarLinkStyleButton(
                                  controller: controller.quillController),

                              // IconBut/*ton(
                              //     icon: Icon(Icons.lte_mobiledata_rounded,),
                              //
                              //     onPressed: (){}
                              // ),*/
                              const VerticalDivider(),
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
