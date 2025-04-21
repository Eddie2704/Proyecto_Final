import 'package:flutter/material.dart';
import 'package:trainathomeapp/models/rutinas.dart';

class JournalProvider with ChangeNotifier {
  final Map<String, Rutina?> _rutinasPorDia = {
    'Lunes': null,
    'Martes': null,
    'Miércoles': null,
    'Jueves': null,
    'Viernes': null,
    'Sábado': null,
    'Domingo': null,
  };

  Map<String, Rutina?> get rutinasAsignadas => _rutinasPorDia;

  void asignarRutina(String dia, Rutina rutina) {
    _rutinasPorDia[dia] = rutina;
    notifyListeners();
  }

  void quitarRutina(String dia) {
    _rutinasPorDia[dia] = null;
    notifyListeners();
  }
}
