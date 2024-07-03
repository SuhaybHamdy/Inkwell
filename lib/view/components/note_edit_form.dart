import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../controllers/add_or_edit_note_controller.dart';
import '../../localization/local.dart';
import '../widget/note_add_or_edit_widgets/build_editor_card.dart';
import '../widget/note_add_or_edit_widgets/build_form.dart';

class NoteEditForm extends GetView<AddOrEditNoteController> {
  const NoteEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    final AddOrEditNoteController controller =
        Get.find<AddOrEditNoteController>();
    return GetBuilder<AddOrEditNoteController>(
      builder: (controller) {
        return SingleChildScrollView(
            child: Container(
              // color: Colors.transparent,
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: controller.expanded.isFalse
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppBar(
                            title: Text(L10n.addTitle.tr),
                            actions: [
                              InkWell(
                                onTap: () => controller.saveOrUpdateNote(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(8.0),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Text(L10n.save.tr,
                                      style: Get.textTheme.bodyMedium!.copyWith(
                                          color:
                                              Get.theme.colorScheme.onPrimary)),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 210.0),
                          NoteForm(),
                          // ],
                        ],
                      )
                    : Container(
                        height: Get.height,
                        width: Get.width,
                      ),
              ),
              Obx(() => AnimatedPositioned(
                    duration: const Duration(milliseconds: 400),
                    top: controller.expanded.isFalse ? 100 : 0,
                    left: controller.expanded.isFalse ? 16 : 0,
                    right: controller.expanded.isFalse ? 16 : 0,
                    // bottom: controller.expanded.isFalse ? 0 : 0,
                    height: controller.expanded.isFalse ? 200 : Get.height,

                    child: buildEditorCard(controller),
                  )),
            ],
          ),
        ));
      },
    );
  }
}
