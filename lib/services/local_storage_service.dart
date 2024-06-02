import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import '../models/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





import 'package:firebase_auth/firebase_auth.dart';



final _firestore = FirebaseFirestore.instance;

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser!.uid;

  Future<void> addNote(Note note) async {
    DocumentReference docRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc();
    note.id = docRef.id;
    await docRef.set(note.toJson());
  }

  Future<void> updateNote(Note note) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(note.id)
        .update(note.toJson());
  }

  Future<void> deleteNote(String noteId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  Future<Note?> getNoteById(String noteId) async {
    DocumentSnapshot noteSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .doc(noteId)
        .get();
    if (noteSnapshot.exists) {
      return Note.fromJson(noteSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Note>> getNotes() async {
    QuerySnapshot notesSnapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('notes')
        .get();
    return notesSnapshot.docs
        .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}



// class NotesService {
//   final GetStorage _storage = GetStorage();
//   Future<List<Note>> loadNotes(String uid) async {
//     try {
//       if (kIsWeb || !_storage.hasData('notes')) {
//         return await FirebaseService.loadNotesFromFirebase(uid);
//       } else {
//         final notesString = _storage.read('notes');
//         final List<dynamic> decodedNotes = jsonDecode(notesString) as List<dynamic>;
//         return decodedNotes.map((note) => Note.fromJson(note)).toList();
//       }
//     } catch (e) {
//       // Handle error (e.g., logging)
//       print("Error loading notes: $e");
//       return [];
//     }
//   }

//   Future<void> saveNote(Note note,String uid) async {
//     try {
//       // Load existing notes
//       List<Note> notes = await loadNotes(uid);

//       // Add or update note
//       int index = notes.indexWhere((existingNote) => existingNote.id == note.id);
//       if (index != -1) {
//         notes[index] = note;
//       } else {
//         notes.add(note);
//       }

//       // Save updated list to local storage
//       await _storage.write('notes', jsonEncode(notes.map((n) => n.toJson()).toList()));

//       // Save to Firebase Firestore
//       await FirebaseService.saveNoteToFirebase(note,uid);
//     } catch (e) {
//       // Handle error (e.g., logging)
//       print("Error saving note: $e");
//     }
//   }

//   Future<void> deleteNote(String noteId,String uid) async {
//     try {
//       // Load existing notes
//       List<Note> notes = await loadNotes(uid);

//       // Remove the note with the given id
//       notes.removeWhere((note) => note.id == noteId);

//       // Save updated list to local storage
//       await _storage.write('notes', jsonEncode(notes.map((n) => n.toJson()).toList()));

//       // Delete from Firebase Firestore
//       await FirebaseService.deleteNoteFromFirebase(noteId);
//     } catch (e) {
//       // Handle error (e.g., logging)
//       print("Error deleting note: $e");
//     }
//   }
// }

// Assuming Firebase related methods are moved to a separate FirebaseService
class FirebaseService {
  static Future<List<Note>> loadNotesFromFirebase(String uid) async {
    final querySnapshot = await _firestore.collection('users').doc(uid).collection('notes').get();
    final notes = querySnapshot.docs.map((doc) => Note.fromJson(doc.data())).toList();
    return notes;
  }

  static Future<void> saveNoteToFirebase(Note note, String uid) async {
    await _firestore.collection('users').doc(uid).
    collection('notes').doc(note.id).set(note.toJson());
  }

  static Future<void> deleteNoteFromFirebase(String noteId) async {
    await _firestore.collection('notes').doc(noteId).delete();
  }
}
