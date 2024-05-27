import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../models/note.dart';
import 'firebase_service.dart'; // Assuming Firebase related methods are in this service

class LocalStorageService {
  final GetStorage _storage = GetStorage();

  Future<List<Note>> loadNotes() async {
    try {
      if (kIsWeb || !_storage.hasData('notes')) {
        return await FirebaseService.loadNotesFromFirebase();
      } else {
        final notesString = _storage.read('notes');
        final List<dynamic> decodedNotes = jsonDecode(notesString) as List<dynamic>;
        return decodedNotes.map((note) => Note.fromJson(note)).toList();
      }
    } catch (e) {
      // Handle error (e.g., logging)
      print("Error loading notes: $e");
      return [];
    }
  }

  Future<void> saveNote(Note note) async {
    try {
      // Load existing notes
      List<Note> notes = await loadNotes();

      // Add or update note
      int index = notes.indexWhere((existingNote) => existingNote.id == note.id);
      if (index != -1) {
        notes[index] = note;
      } else {
        notes.add(note);
      }

      // Save updated list to local storage
      await _storage.write('notes', jsonEncode(notes.map((n) => n.toJson()).toList()));

      // Save to Firebase Firestore
      await FirebaseService.saveNoteToFirebase(note);
    } catch (e) {
      // Handle error (e.g., logging)
      print("Error saving note: $e");
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      // Load existing notes
      List<Note> notes = await loadNotes();

      // Remove the note with the given id
      notes.removeWhere((note) => note.id == noteId);

      // Save updated list to local storage
      await _storage.write('notes', jsonEncode(notes.map((n) => n.toJson()).toList()));

      // Delete from Firebase Firestore
      await FirebaseService.deleteNoteFromFirebase(noteId);
    } catch (e) {
      // Handle error (e.g., logging)
      print("Error deleting note: $e");
    }
  }
}

// Assuming Firebase related methods are moved to a separate FirebaseService
class FirebaseService {
  static Future<List<Note>> loadNotesFromFirebase() async {
    final querySnapshot = await _firestore.collection('notes').get();
    final notes = querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    return notes;
  }

  static Future<void> saveNoteToFirebase(Note note) async {
    await _firestore.collection('notes').doc(note.id).set(note.toJson());
  }

  static Future<void> deleteNoteFromFirebase(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
