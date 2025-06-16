import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RefuseModel {
  final String id;
  final DateTime createdAt;

  RefuseModel({
    required this.id,
    required this.createdAt,
  });

  // Convert to Map for JSON serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Map
  factory RefuseModel.fromMap(Map<String, dynamic> map) {
    return RefuseModel(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
