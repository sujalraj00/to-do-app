import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_app/core/constants/utils.dart';

class TaskModel {
  final String id;
  final String uuid;
  final String title;
  final Color color;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime dueAt;

  TaskModel(
      {required this.id,
      required this.color,
      required this.uuid,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.dueAt});

  TaskModel copyWith(
      {String? id,
      String? uuid,
      String? title,
      String? description,
      DateTime? createdAt,
      DateTime? updatedAt,
      DateTime? dueAt,
      Color? color}) {
    return TaskModel(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        dueAt: dueAt ?? this.dueAt,
        color: color ?? this.color);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'title': title,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'color': rgbToHex(color)
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        id: map['id'] ?? '',
        uuid: map['uuid'] ?? '',
        title: map['title'] ?? '',
        description: map['description'] ?? '',
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
        dueAt: DateTime.parse(map['dueAt']),
        color: hexToRgb(map['hexColor']));
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uuid: $uuid, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, dueAt: $dueAt, color: $color)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.dueAt == dueAt &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        dueAt.hashCode ^
        color.hashCode;
  }
}
