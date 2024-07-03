import 'package:flutter/material.dart';

class NoteStatus {
  final String name;
  final Color color;

  const NoteStatus._(this.name, this.color);

  static const NoteStatus pending = NoteStatus._('Pending', Color(0xffeed68a));
  static const NoteStatus inProgress = NoteStatus._('In Progress', Color(0xffffc05e));
  static const NoteStatus completed = NoteStatus._('Completed', Color(0xff44ef57));

  static List<NoteStatus> get values => [pending, inProgress, completed];

  @override
  String toString() => name;

  static NoteStatus fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    Color color = Color(json['color']);
    return NoteStatus._(name, color);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value,
    };
  }

  static NoteStatus fromFirebase(Map<String, dynamic> data) {
    String name = data['name'];
    int colorValue = data['color'];
    Color color = Color(colorValue);
    return NoteStatus._(name, color);
  }

  Map<String, dynamic> toFirebase() {
    return {
      'name': name,
      'color': color.value,
    };
  }
}

extension NoteStatusExtension on NoteStatus {
  String get string => toString().split('.').last;

  static NoteStatus fromString(String status) {
    return NoteStatus.values.firstWhere((e) => e.string == status);
  }
}
