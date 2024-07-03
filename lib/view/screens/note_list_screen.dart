import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/controllers/add_or_edit_note_controller.dart';
import 'package:inkwell/controllers/auth_controller.dart';
import 'package:inkwell/controllers/note_controller.dart';
import 'package:inkwell/models/note_status.dart';
import 'package:inkwell/routes/app_routes.dart';
import 'package:inkwell/theme/theme.dart';
import 'package:inkwell/view/components/drawer.dart';

import '../../models/note.dart';
import '../../services/ai_suggest.dart';
import '../../theme/util.dart';
import '../widget/home/custom_app_bar.dart';
import 'notes/notes_list/ai_suggest_dialog/ai_suggest_dialog.dart';
import 'notes/notes_list/ai_suggest_dialog/init_dialog.dart';
import 'notes/notes_list/notes_calendar.dart';
import 'notes/notes_list/notes_grid.dart';
import 'notes/notes_list/notes_list.dart';

class NoteListScreen extends StatelessWidget {
  final NotesController controller = Get.find<NotesController>();
  final AuthController authController = Get.find();
  final AiSuggesterService aiSuggesterService = AiSuggesterService();

  NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      builder: (controller) {
        controller.update();
        TextTheme textTheme =
            createTextTheme(Get.context!, "Allerta", "Akaya Kanadaka");
        MaterialTheme theme = MaterialTheme(textTheme);

        return Scaffold(
          backgroundColor: Get.theme.colorScheme.background,
          appBar: controller.viewMode.value != ViewMode.calendar
              ? CustomAppBar(
                  title: 'Inkwell',
                  searchController: controller.searchController,
                  onSearch: () {
                    controller.searchNotes(controller.searchController.text);
                  },
                  onOpenDrawer: () {
                    Scaffold.of(context).openDrawer();
                  },
                  iaSuggest: () {
                    showCustomSuggestionDialog(context,aiSuggesterService );
                  },
                )
              : AppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.noteDetail),
            child: const Icon(Icons.note_add),
          ),
          body: GetBuilder<NotesController>(
            builder: (controller) {
              if (controller.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredNotes.isEmpty) {
                return Center(
                  child: Text(
                    'There is no note yet',
                    style: Get.textTheme.bodyLarge,
                  ),
                );
              }

              switch (controller.viewMode.value) {
                case ViewMode.list:
                  return NoteListView(
                      notes: controller.filteredNotes, controller: controller);
                case ViewMode.grid:
                  return NoteGridView(
                      notes: controller.filteredNotes, controller: controller);
                case ViewMode.calendar:
                  return NoteCalendarView(
                      notes: controller.filteredNotes, controller: controller);
                default:
                  return NoteListView(
                      notes: controller.filteredNotes, controller: controller);
              }
            },
          ),
          drawer: CustomDrawer(),
        );
      },
    );
  }
}