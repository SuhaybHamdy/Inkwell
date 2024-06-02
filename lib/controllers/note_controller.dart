import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inkwell/models/note.dart';

import '../routes/app_routes.dart';
import '../services/local_storage_service.dart';

class NoteController extends GetxController {
  final RxList<Note> notes = RxList<Note>([]);
  final NotesService _notesService = NotesService();

  Note? currentNote;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  QuillController quillController = QuillController.basic();
  final ScrollController scrollController = ScrollController();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final GetStorage _box = GetStorage();

  RxBool isAuth = RxBool(true);
  bool isShowToolbar = true;
  var filteredNotes = <Note>[].obs;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(_onSearchChanged);
    initAuth();
  }

  void _onSearchChanged() {
    searchNotes(searchController.text);
  }

  void initAuth() {
    if (isAuth.isTrue) {
      _loadNotes();
      initializeNote();
    } else {
      Get.toNamed(AppRoutes.login);
    }
  }

  Future<void> initializeNote() async {
    final arguments = Get.arguments;
    if (arguments != null && arguments is String) {
      currentNote = _findNoteById(arguments);
    }

    if (currentNote != null) {
      await _initializeQuillControllerWithNoteContent(currentNote!);
    } else {
      _initializeBasicQuillController();
    }

    update();
  }

  Note? _findNoteById(String id) {
    return notes.firstWhereOrNull((note) => note.id == id);
  }

  Future<void> _initializeQuillControllerWithNoteContent(Note note) async {
    try {
      titleController.text = note.title;
      final deltaJson = jsonDecode(note.content) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);

      quillController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _initializeBasicQuillController();
    }
  }

  String extractPlainTextFromNoteContent(Note note) {
    try {
      final deltaJson = jsonDecode(note.content) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);
      var controllerQuill = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
      return controllerQuill.document.toPlainText();
    } catch (e) {
      return '';
    }
  }

  void _initializeBasicQuillController() {
    quillController = QuillController.basic();
  }

  Future<void> _loadNotes() async {
    try {
      final loadedNotes = await _notesService.getNotes();
      notes.assignAll(loadedNotes);
      filteredNotes.assignAll(notes);
    } catch (e) {
      _showErrorSnackbar('Failed to load notes: $e');
    }
    update();
  }

  Future<void> saveNote() async {
    if (currentNote != null) {
      currentNote!.title = titleController.text;
      currentNote!.content =
          jsonEncode(quillController.document.toDelta().toJson());
      print('the title has been saved: ${currentNote!.title}');

      try {
        await _notesService.addNote(currentNote!);
        final index = notes.indexWhere((note) => note.id == currentNote!.id);
        if (index != -1) {
          notes[index] = currentNote!;
        } else {
          notes.add(currentNote!);
        }
        filteredNotes.assignAll(notes);
      } catch (e) {
        _showErrorSnackbar('Failed to save note: $e');
      }
      await _loadNotes();
      update();
    }
  }

  Future<void> deleteNote() async {
    if (currentNote != null) {
      try {
        await _notesService.deleteNote(currentNote!.id!);
        notes.removeWhere((note) => note.id == currentNote!.id);
        filteredNotes.assignAll(notes);
      } catch (e) {
        _showErrorSnackbar('Failed to delete note: $e');
      }
      update();
    }
  }

  void editNote() {
    if (currentNote != null) {
      final index = notes.indexWhere((note) => note.id == currentNote!.id);
      if (index != -1) {
        notes[index] = currentNote!;
        update();
      } else {
        _showErrorSnackbar('Note not found for editing');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  void toggleToolbar() {
    isShowToolbar = !isShowToolbar;
    update();
  }

  void searchNotes(String query) {
    if (query.isEmpty) {
      filteredNotes.assignAll(notes);
    } else {
      filteredNotes.assignAll(
        notes
            .where((note) =>
                note.title.contains(query) || note.content.contains(query))
            .toList(),
      );
    }
    update();
  }
}
