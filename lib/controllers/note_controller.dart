// lib/controllers/note_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inkwell/models/note.dart';
import 'package:inkwell/services/local_storage_service.dart';  // Replace with your actual service

class NoteController extends GetxController {
  final RxList<Note> notes = RxList<Note>([]); // List of notes in memory

  @override
  void onInit() {
    super.onInit();
    _loadNotes(); // Load notes on app initialization
  }

  Future<void> _loadNotes() async {
    try {
      final loadedNotes = await LocalStorageService.loadNotes(); // Replace with your service call
      notes.assignAll(loadedNotes); // Update in-memory list
    } catch (e) {
      print("Error loading notes: $e"); // Handle loading errors
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      await LocalStorageService.saveNote(note); // Replace with your service call
      notes.add(note); // Update in-memory list (assuming successful save)
    } catch (e) {
      print("Error saving note: $e"); // Handle saving errors
    }
  }

  // Additional methods for editing notes, deleting notes, etc.
  void editNote(Note note) {
    // Implement logic to edit the note in the list (e.g., update content)
    // Update UI using update() or other GetX methods
  }

  void deleteNote(Note note) {
    try {
      await LocalStorageService.deleteNote(note.id); // Replace with your service call
      notes.removeWhere((element) => element.id == note.id); // Update in-memory list
    } catch (e) {
      print("Error deleting note: $e"); // Handle deletion errors
    }
  }
}
