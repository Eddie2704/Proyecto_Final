class Rutina {
  String id;
  String name;
  String type;
  int time;
  List<Map<String, dynamic>> ejercicios;

  Rutina({
    required this.id,
    required this.name,
    required this.type,
    required this.time,
    required this.ejercicios,
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      time: json['time'],
      ejercicios: List<Map<String, dynamic>>.from(json['ejercicios'] ?? []),
    );
  }

  Map<String, dynamic> toFirestoreDataBase() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'time': time,
      'ejercicios': ejercicios,
    };
  }
}
