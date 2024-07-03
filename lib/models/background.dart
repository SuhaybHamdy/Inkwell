import 'package:flutter/material.dart';

import 'note.dart';

class Background {
  final String? type;
  final String? value;

  Background({this.type, this.value});

  factory Background.fromJson(Map<String, dynamic> json) {
    return Background(
      type: json['type'] as String?,
      value: json['value'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
    };
  }

  // Added copyWith method
  Background copyWith({
    String? type,
    String? value,
  }) {
    return Background(
      type: type ?? this.type,
      value: value ?? this.value,
    );
  }
}

