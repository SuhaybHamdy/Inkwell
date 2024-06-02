import 'package:flutter_quill/flutter_quill.dart';

class Note {
  String? id;
   String title;

   String content;
   List<String>? categories;
   List<String>? tags;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.categories,
    this.tags,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'categories': categories,
      'tags': tags,
    };
  }
}

class Todo {
  final String id;
  final String title;
  final bool completed;
  final String category;
  final List<String> tags;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.category,
    required this.tags,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      completed: json['completed'] as bool,
      category: json['category'] as String,
      tags: (json['tags'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'completed': completed,
      'category': category,
      'tags': tags,
    };
  }
}
