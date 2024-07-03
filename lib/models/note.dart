import 'package:flutter/material.dart';
import 'package:inkwell/models/background.dart';

// Assuming NoteStatus and Schedule are already defined classes.
import '../services/ai_suggest.dart';
import 'note_status.dart';
import 'schedule.dart';

class Note {
  String? id;
  String? title;
  String? content;
  DateTime? date;
  List<String>? tags;
  bool? isImportant;
  bool? isHint;
  Color? color;
  String? category;
  Background? background;
  String? location;
  String? folderPath;
  List<String>? attachments;
  DateTime? reminder;
  DateTime? lastEdited;
  String? author;
  String? priority;
  List<String>? checklist;
  List<String>? relatedLinks;
  List<String>? collaborators;
  NoteStatus? status;
  Schedule? repeatInterval;

  Note({
    this.id,
    this.title,
    this.content,
    this.date,
    this.tags,
    this.isImportant,
    this.isHint,
    this.color,
    this.category,
    this.background,
    this.location,
    this.folderPath,
    this.attachments,
    this.reminder,
    this.lastEdited,
    this.author,
    this.priority,
    this.checklist,
    this.relatedLinks,
    this.collaborators,
    this.status,
    this.repeatInterval,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? date,
    List<String>? tags,
    bool? isImportant,
    bool? isHint,
    Color? color,
    String? category,
    Background? background,
    String? location,
    String? folderPath,
    List<String>? attachments,
    DateTime? reminder,
    DateTime? lastEdited,
    String? author,
    String? priority,
    List<String>? checklist,
    List<String>? relatedLinks,
    List<String>? collaborators,
    NoteStatus? status,
    Schedule? repeatInterval,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      tags: tags ?? List.from(this.tags ?? []),
      isImportant: isImportant ?? this.isImportant,
      isHint: isHint ?? this.isHint,
      color: color ?? this.color,
      category: category ?? this.category,
      background: background ?? this.background,
      location: location ?? this.location,
      folderPath: folderPath ?? this.folderPath,
      attachments: attachments ?? List.from(this.attachments ?? []),
      reminder: reminder ?? this.reminder,
      lastEdited: lastEdited ?? this.lastEdited,
      author: author ?? this.author,
      priority: priority ?? this.priority,
      checklist: checklist ?? List.from(this.checklist ?? []),
      relatedLinks: relatedLinks ?? List.from(this.relatedLinks ?? []),
      collaborators: collaborators ?? List.from(this.collaborators ?? []),
      status: status ?? this.status,
      repeatInterval: repeatInterval ?? this.repeatInterval,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    print('this is a note content json is : ${json['content'].toString()}');
    return Note(
      id: json['id'] as String?,
      title: json['title'] as String?,
      content: '${json['content']}',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      isImportant: json['isImportant'] as bool?,
      isHint: json['isHint'] as bool?,
      color: json['color'] != null ? Color(json['color']) : null,
      category: json['category'] as String?,
      background: json['background'] != null
          ? Background.fromJson(json['background'])
          : null,
      location: json['location'] as String?,
      folderPath: json['folderPath'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)?.cast<String>(),
      reminder:
          json['reminder'] != null ? DateTime.parse(json['reminder']) : null,
      lastEdited: json['lastEdited'] != null
          ? DateTime.parse(json['lastEdited'])
          : null,
      author: json['author'] as String?,
      priority: json['priority'] as String?,
      checklist: (json['checklist'] as List<dynamic>?)?.cast<String>(),
      relatedLinks: (json['relatedLinks'] as List<dynamic>?)?.cast<String>(),
      collaborators: (json['collaborators'] as List<dynamic>?)?.cast<String>(),
      status: json['status'] != null
          ? NoteStatus.values.firstWhere((e) => e.name == json['status'])
          : null,
      repeatInterval: json['repeatInterval'] != null
          ? Schedule.fromJson(json['repeatInterval'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date?.toIso8601String(),
      'tags': tags,
      'isImportant': isImportant,
      'isHint': isHint,
      'color': color?.value,
      'category': category,
      'background': background?.toJson(),
      'location': location,
      'folderPath': folderPath,
      'attachments': attachments,
      'reminder': reminder?.toIso8601String(),
      'lastEdited': lastEdited?.toIso8601String(),
      'author': author,
      'priority': priority,
      'checklist': checklist,
      'relatedLinks': relatedLinks,
      'collaborators': collaborators,
      'status': status?.name,
      'repeatInterval': repeatInterval?.toJson(),
    };
  }

  factory Note.fromFirebase(Map<String, dynamic> data) {
    return Note(
      id: data['id'] as String?,
      title: data['title'] as String?,
      content: data['content'] as String?,
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
      tags: (data['tags'] as List<dynamic>?)?.cast<String>(),
      isImportant: data['isImportant'] as bool?,
      isHint: data['isHint'] as bool?,
      color: data['color'] != null ? Color(data['color']) : null,
      category: data['category'] as String?,
      background: data['background'] != null
          ? Background.fromJson(data['background'])
          : null,
      location: data['location'] as String?,
      folderPath: data['folderPath'] as String?,
      attachments: (data['attachments'] as List<dynamic>?)?.cast<String>(),
      reminder:
          data['reminder'] != null ? DateTime.parse(data['reminder']) : null,
      lastEdited: data['lastEdited'] != null
          ? DateTime.parse(data['lastEdited'])
          : null,
      author: data['author'] as String?,
      priority: data['priority'] as String?,
      checklist: (data['checklist'] as List<dynamic>?)?.cast<String>(),
      relatedLinks: (data['relatedLinks'] as List<dynamic>?)?.cast<String>(),
      collaborators: (data['collaborators'] as List<dynamic>?)?.cast<String>(),
      status: data['status'] != null
          ? NoteStatus.values.firstWhere((e) => e.name == data['status'])
          : null,
      repeatInterval: data['repeatInterval'] != null
          ? Schedule.fromJson(data['repeatInterval'])
          : null,
    );
  }

  Map<String, dynamic> toFirebase() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date?.toIso8601String(),
      'tags': tags,
      'isImportant': isImportant,
      'isHint': isHint,
      'color': color?.value,
      'category': category,
      'background': background?.toJson(),
      'location': location,
      'folderPath': folderPath,
      'attachments': attachments,
      'reminder': reminder?.toIso8601String(),
      'lastEdited': lastEdited?.toIso8601String(),
      'author': author,
      'priority': priority,
      'checklist': checklist,
      'relatedLinks': relatedLinks,
      'collaborators': collaborators,
      'status': status?.name,
      'repeatInterval': repeatInterval?.toJson(),
    };
  }
}
