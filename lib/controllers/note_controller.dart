import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:get/get.dart';
import '../services/local_storage_service.dart';
import '../models/note.dart';

class NoteController extends GetxController {
  final RxList<Note> notes = RxList<Note>([]); // List of notes in memory
  final LocalStorageService _localStorageService =
      LocalStorageService(); // Instance of the service

  Note? note;
  TextEditingController titleController = TextEditingController();
  QuillController quillController = QuillController.basic();
  ScrollController scrollController = ScrollController();

  bool isShowToolbar = true;

  @override
  void onInit() {
    super.onInit();
    _loadNotes(); // Load notes on app initialization
    initializeNote();
  }

  Future<void> initializeNote() async {
    final arguments = Get.arguments;

    Note? noteValue;
    if (arguments != null && arguments is String) {
      noteValue = _findNoteById(arguments);
    }

    if (noteValue != null) {
      await _initializeQuillControllerWithNoteContent(noteValue);
    } else {
      _initializeBasicQuillController();
    }

    update();
  }

  Note? _findNoteById(String id) {
    try {
      return notes.firstWhereOrNull((element) => element.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> _initializeQuillControllerWithNoteContent(
      Note? noteValue) async {
    try {
      titleController.text = noteValue!.title;

      final deltaJson = jsonDecode(noteValue.content) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);

      quillController = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } catch (e) {
      _initializeBasicQuillController();
    }
  }

  String extractPlainTextFromNoteContent(Note noteValue) {
    try {
      final deltaJson = jsonDecode(noteValue.content) as List<dynamic>;
      final delta = Delta.fromJson(deltaJson);
      var controllerQuill = QuillController(
        document: Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
      // Convert Delta to plain text
      final plainText = controllerQuill.document.toPlainText();

      return plainText;
    } catch (e) {
      // Handle error and return empty string or some default value
      return '';
    }
  }

  void _initializeBasicQuillController() {
    quillController = QuillController.basic();
  }

  Future<void> _loadNotes() async {
    try {
      final loadedNotes = await _localStorageService.loadNotes();
      // loadedNotes.forEach((noteLoaded) {
      //  Note noteJson=noteLoaded;
      //  Document content = noteJson.content
      //  Note  noteConverted=Note(title: noteJson.title, content: )
      //
      // });
      notes.assignAll(loadedNotes); // Update in-memory list
    } catch (e) {
      _showErrorSnackbar('Failed to load notes: $e');
    }
    update();
  }

  Future<void> saveNote(Note note) async {
    try {
      print('Starting saveNote process');

      // Saving the note to local storage
      print('Saving note to local storage');
      await _localStorageService.saveNote(note);

      // Finding the index of the existing note in the list
      print('Checking if note already exists in the list');
      int index =
          notes.indexWhere((existingNote) => existingNote.id == note.id);

      if (index != -1) {
        // If note exists, update the note in the list
        print('Note exists, updating note at index $index');
        notes[index] = note;
      } else {
        // If note does not exist, add it to the list
        print('Note does not exist, adding new note to the list');
        notes.add(note);
      }

      // Trigger UI update
      print('Updating UI');
      update();

      print('saveNote process completed successfully');
    } catch (e) {
      // Handle saving errors
      print('Error occurred during saveNote process: $e');
      _showErrorSnackbar('Failed to save note: $e');
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _localStorageService.deleteNote(note.id!);
      notes.removeWhere(
          (element) => element.id == note.id); // Update in-memory list
      update(); // Trigger UI update
    } catch (e) {
      _showErrorSnackbar('Failed to delete note: $e');
    }
  }

  void editNote(Note note) {
    int index = notes.indexWhere((existingNote) => existingNote.id == note.id);
    if (index != -1) {
      notes[index] = note;
      update(); // Trigger UI update
    } else {
      _showErrorSnackbar('Note not found for editing');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
  }

  void toggleToolbar() {
    print('this is toggle toolbar');

    isShowToolbar = !isShowToolbar;
    update();
  }

// Additional methods for other note operations can be added here
}
