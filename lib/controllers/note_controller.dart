import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/note.dart';
import '../services/local_storage_service.dart';

class NoteController extends GetxController {
  final RxList<Note> notes = RxList<Note>([]); // List of notes in memory
  final LocalStorageService _localStorageService = LocalStorageService(); // Instance of the service

  @override
  void onInit() {
    super.onInit();
    _loadNotes(); // Load notes on app initialization
  }

  Future<void> _loadNotes() async {
    try {
      final loadedNotes = await _localStorageService.loadNotes();
      notes.assignAll(loadedNotes); // Update in-memory list
    } catch (e) {
      // Handle loading errors
      Get.snackbar('Error', 'Failed to load notes: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      await _localStorageService.saveNote(note);
      // Check if note already exists in the list
      int index = notes.indexWhere((existingNote) => existingNote.id == note.id);
      if (index != -1) {
        notes[index] = note;
      } else {
        notes.add(note);
      }
      update(); // Trigger UI update
    } catch (e) {
      // Handle saving errors
      Get.snackbar('Error', 'Failed to save note: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteNote(Note note) async {
    try {
      await _localStorageService.deleteNote(note.id);
      notes.removeWhere((element) => element.id == note.id); // Update in-memory list
      update(); // Trigger UI update
    } catch (e) {
      // Handle deletion errors
      Get.snackbar('Error', 'Failed to delete note: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void editNote(Note note) {
    // Implement logic to edit the note in the list (e.g., update content)
    int index = notes.indexWhere((existingNote) => existingNote.id == note.id);
    if (index != -1) {
      notes[index] = note;
      update(); // Trigger UI update
    } else {
      Get.snackbar('Error', 'Note not found for editing',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

// Additional methods for other note operations can be added here
}
