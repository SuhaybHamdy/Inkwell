// TODO Implement this library.

class Note {
  final String id;
  final String title;
  final String content;
  final List<String> categories;
  final List<String> tags;

  Note(this.id, this.title, this.content, this.categories, this.tags);

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    json['id'] as String,
    json['title'] as String,
    json['content'] as String,
    (json['categories'] as List<dynamic>).cast<String>(),
    (json['tags'] as List<dynamic>).cast<String>(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'categories': categories,
    'tags': tags,
  };
}
class Todo {
  final String id;
  final String title;
  final bool completed;
  final String category;
  final List<String> tags;

  Todo(this.id, this.title, this.completed, this.category, this.tags);

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    json['id'] as String,
    json['title'] as String,
    json['completed'] as bool,
    json['category'] as String,
    (json['tags'] as List<dynamic>).cast<String>(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
    'category': category,
    'tags': tags,
  };
}
