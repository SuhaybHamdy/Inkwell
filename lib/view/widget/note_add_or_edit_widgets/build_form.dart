import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart' as md;
import 'package:intl/intl.dart';
import 'package:inkwell/controllers/note_controller.dart';
import '../../../controllers/add_or_edit/functions.dart';
import '../../../controllers/add_or_edit_note_controller.dart';
import '../../../localization/l10n.dart';
import '../../screens/notes/add_or_edit_note/schedule_form.dart';
import '../my_quill_toolbar.dart';
import 'the_background_notes.dart';
import 'themed_dropdown.dart';

class NoteForm extends StatelessWidget {
  final AddOrEditNoteController controller = Get.find();
  final NotesController notesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        // color: Get.theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            buildSectionHeader(L10n.timing.tr),
            buildAllDaySwitch(),
            buildDateTimeTile(
              title: L10n.start.tr,
              dateTime: controller.startDateTime,
              onTap: () async => await selectDate(
                controller.startDateTime,
                controller.updateStartDateTime,
              ),
            ),
            buildDateTimeTile(
              title: L10n.end.tr,
              dateTime: controller.endDateTime,
              onTap: () async => await selectDate(
                controller.endDateTime,
                controller.updateEndDateTime,
              ),
            ),
            buildTimezoneTile(),
            buildNoRepeatTile(),
            const SizedBox(height: 16.0),
            buildSectionHeader(L10n.color.tr),
            TheBackgroundNotes(),
            const SizedBox(height: 16.0),
            buildSectionHeader(L10n.category.tr),
            ThemedDropdown(),
            const SizedBox(height: 16.0),
            buildToggles(),
            const SizedBox(height: 16.0),
            buildAttachments(),
            const SizedBox(height: 16.0),
            buildPriorityDropdown(),
            const SizedBox(height: 16.0),
            buildChecklist(),
            const SizedBox(height: 16.0),
            buildTagsInput(),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Text(
      title,
      style: Get.textTheme.headline6?.copyWith(
        fontWeight: FontWeight.bold,
        color: Get.theme.colorScheme.primary,
      ),
    );
  }

  Widget buildChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(L10n.checklist.tr, style: Get.textTheme.headline6),
        ...controller.currentNote!.checklist!.map((item) => CheckboxListTile(
              title: Text(item),
              value: controller.completedItems.contains(item),
              onChanged: (bool? value) {
                controller.toggleChecklistItem(item);
              },
            )),
        ListTile(
          leading: Icon(Icons.add),
          title: Text(L10n.addItem.tr),
          onTap: () => _showAddChecklistItemDialog(),
        ),
      ],
    );
  }

  void _showAddChecklistItemDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(L10n.addChecklistItem.tr),
        content: TextField(
          onSubmitted: (value) {
            controller.addChecklistItem(value);
            Get.back();
          },
        ),
      ),
    );
  }

  Widget buildPriorityDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: L10n.priority.tr),
      value: controller.priority.value,
      items: ['Low', 'Medium', 'High'].map((String priority) {
        return DropdownMenuItem<String>(
          value: priority,
          child: Text(priority),
        );
      }).toList(),
      onChanged: (String? newValue) {
        controller.updatePriority(newValue!);
      },
    );
  }

  Widget buildAttachments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(L10n.attachments.tr, style: Get.textTheme.headline6),
        Wrap(
          spacing: 8.0,
          children: [
            ...controller.attachments.map((attachment) => Chip(
                  label: Text(attachment),
                  onDeleted: () => controller.removeAttachment(attachment),
                )),
            ActionChip(
              label: Text(L10n.addAttachment.tr),
              onPressed: () => controller.addAttachment(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildToggles() {
    return Column(
      children: [
        SwitchListTile(
          title: Text(L10n.important.tr),
          value: controller.isImportant.value,
          onChanged: (value) => controller.toggleImportant(),
        ),
        SwitchListTile(
          title: Text(L10n.hint.tr),
          value: controller.isHint.value,
          onChanged: (value) => controller.toggleHint(),
        ),
      ],
    );
  }

  Widget buildTagsInput() {
    return Wrap(
      spacing: 8.0,
      children: [
        ...controller.tags.map((tag) => Chip(
              label: Text(tag.name!),
              // onDeleted: () => controller.removeTag(tag),
            )),
        InputChip(
          label: Text(L10n.addTag.tr),
          onPressed: () => _showAddTagDialog(),
        ),
      ],
    );
  }

  void _showAddTagDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(L10n.addTag.tr),
        content: TextField(
          onSubmitted: (value) {
            controller.addTag(value);
            Get.back();
          },
        ),
      ),
    );
  }

  Widget buildAllDaySwitch() {
    return Obx(() => ListTile(
          title: Text(L10n.allDay.tr),
          trailing: Switch(
            value: controller.isAllDay.value,
            onChanged: controller.toggleAllDay,
          ),
        ));
  }

  Widget buildDateTimeTile({
    required String title,
    required Rx<DateTime> dateTime,
    required Function() onTap,
  }) {
    return Obx(() => ListTile(
          title: Text(title),
          subtitle: Text(
              DateFormat('hh:mm a EEEE, d MMM yyyy').format(dateTime.value)),
          trailing: const Icon(Icons.calendar_today),
          onTap: onTap,
        ));
  }

  Widget buildTimezoneTile() {
    return Obx(() => ListTile(
          title: Text(L10n.timezone.tr),
          subtitle: Text(controller.timezone.value),
          trailing: const Icon(Icons.access_time),
          onTap: () {
            // Select timezone logic
          },
        ));
  }

  Widget buildNoRepeatTile() {
    return ListTile(
      title: Text(
          controller.currentNote?.repeatInterval?.repeatOption.name.tr ??
              L10n.noRepeat.tr),
      trailing: const Icon(Icons.repeat),
      onTap: () {
        Get.to(const ScheduleForm());
      },
    );
  }

  Widget buildElevatedButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
