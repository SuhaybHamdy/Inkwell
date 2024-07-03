import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inkwell/controllers/note_controller.dart';
import '../../models/category.dart';
import '../../models/note.dart';

class NoteCard extends GetView<NotesController> {
  final Note note;
  final Function() onTap;
  final Function(Note) onDelete;
  final Function(Note) onEdit;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  Future<quill.QuillController> _initializeQuillControllerWithNoteContent(
      Note note) async {
    try {
      final deltaJson = jsonDecode(note.content!) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);

      return quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      return QuillController.basic();
    }
  }


  @override
  Widget build(BuildContext context) {
    final noteDate = note.lastEdited != null ? DateFormat.yMMMd().format(note.lastEdited!) : 'No date';
    Category? category = note.category != null && controller.categories.isNotEmpty
        ? controller.categories.firstWhere((cat) => cat.id == note.category)
        : null;

    final TextStyle titleStyle = TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: controller.invertColor(category?.color) ??
          controller.invertColor(note.color) ??
          Get.textTheme.titleLarge!.color,
    );

    final TextStyle contentStyle = TextStyle(
      fontSize: 16.0,
      color: controller.invertColor(category?.color) ??
          controller.invertColor(note.color) ??
          Get.theme.colorScheme.primary,
    );

    final BoxDecoration backgroundDecoration = BoxDecoration(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(8),
      ),
      color: note.background != null && note.background!.type == 'color'
          ? controller.parseColor(note.background!.value).withOpacity(0.5)
          : Colors.transparent,
      image: note.background != null && note.background!.type == 'wallpaper'
          ? DecorationImage(
        image: AssetImage(note.background!.value!),
        fit: BoxFit.cover,
      )
          : null,
    );

    return FutureBuilder<quill.QuillController>(
      future: _initializeQuillControllerWithNoteContent(note),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error loading note content'));
        }

        final quillController = snapshot.data ?? quill.QuillController.basic();

        return InkWell(
          onTap: onTap,
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _buildCategoryHeader(category),
                _buildNoteContent(quillController, noteDate, titleStyle, contentStyle, backgroundDecoration),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryHeader(Category? category) {
    if (category == null) return Container();

    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: category.color ?? Colors.transparent,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(18.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _categoryViewWidget(category),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit(note);
              } else if (value == 'delete') {
                onDelete(note);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18),
                    SizedBox(width: 8),
                    Text('Delete'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent(
      quill.QuillController quillController,
      String noteDate,
      TextStyle titleStyle,
      TextStyle contentStyle,
      BoxDecoration backgroundDecoration,
      ) {
    return Container(
      decoration: backgroundDecoration,
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.title ?? 'Untitled', style: titleStyle),
            const SizedBox(height: 4.0),
            Text(
              controller.extractPlainTextFromNoteContent(note),
              style: contentStyle,
              maxLines: 10,
            ),
            const SizedBox(height: 4.0),
            if (note.checklist != null && note.checklist!.isNotEmpty)
              _buildChecklist(note.checklist!),
            const SizedBox(height: 4.0),
            Text(
              noteDate,
              style: TextStyle(
                fontSize: 14.0,
                color: Get.theme.colorScheme.onBackground.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChecklist(List<String> checklist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checklist.map((item) {
        return SizedBox(height: 40,
          child: CheckboxListTile(

            title: Text(item,maxLines: 1,),
              value: true, onChanged: ((value){})),
        );

      }).toList(),
    );
  }

  Row _categoryViewWidget(Category category) {
    return Row(
      children: [
        if (category.imageUrl != null)
          Container(
            height: 50,
            width: 50,
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              category.imageUrl!,
              color: controller.invertColor(category.color),
            ),
          ),
        Text(
          category.name.tr,
          style: TextStyle(
            fontSize: 16.0,
            color: controller.invertColor(category.color),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
