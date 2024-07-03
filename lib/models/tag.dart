class Tag {
  final String? id;
  final String? name;

  Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
