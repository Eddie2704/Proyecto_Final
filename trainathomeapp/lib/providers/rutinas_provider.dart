import 'package:cloud_firestore/cloud_firestore.dart';

class Rutina {
  String id;
  String name;
  String type;
  DateTime createdAt;

  Rutina ( {
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    }
  );

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestoreDataBase() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'createdAt': createdAt,
    };
  }
}