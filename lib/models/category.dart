import 'package:flutter/material.dart';

class Category {
  String id;
  String name;
  String? imageUrl; // Optional image URL
  Color? color; // Optional color

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String?,
    color: json['color'] != null ? Color(int.parse(json['color'], radix: 16)) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    if (imageUrl != null) 'imageUrl': imageUrl,
    if (color != null) 'color': color!.value.toRadixString(16),
  };
}
