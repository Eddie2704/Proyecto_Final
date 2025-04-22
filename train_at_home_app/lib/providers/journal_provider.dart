import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainathomeapp/models/rutinas.dart';

class JournalProvider with ChangeNotifier {
  Map<String, List<Rutina>> _rutinasAsignadas = {};

  Map<String, List<Rutina>> get rutinasAsignadas => _rutinasAsignadas;

  JournalProvider() {
    _cargarRutinas(); // Carga rutinas al iniciar la app
  }

  void asignarRutina(String dia, Rutina rutina) {
  if (_rutinasAsignadas[dia] == null) {
    _rutinasAsignadas[dia] = [];
  }

  // Verificar si la rutina ya existe comparando por nombre
  bool existe = _rutinasAsignadas[dia]!.any((r) => r.name == rutina.name);
  if (!existe) {
    _rutinasAsignadas[dia]!.add(rutina);
    _guardarRutinas();
    notifyListeners();
  }
}



  void quitarRutina(String dia, Rutina rutina) {
    _rutinasAsignadas[dia]?.remove(rutina);
    _guardarRutinas(); // Guarda automáticamente
    notifyListeners();
  }

  void borrarTodasRutinas(String dia) {
  _rutinasAsignadas[dia]?.clear();
  _guardarRutinas();
  notifyListeners();
  }


void borrarTodasLasRutinasDeTodosLosDias() {
  _rutinasAsignadas.clear(); 
  _guardarRutinas(); 
  notifyListeners(); 
}


  Future<void> _guardarRutinas() async {
    final prefs = await SharedPreferences.getInstance();
    final rutinasMap = _rutinasAsignadas.map((key, value) => MapEntry(
        key, jsonEncode(value.map((r) => r.toFirestoreDataBase()).toList())));
    await prefs.setString('rutinasAsignadas', jsonEncode(rutinasMap));
  }

  Future<void> _cargarRutinas() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('rutinasAsignadas');
    if (data != null) {
      final decodedMap = jsonDecode(data) as Map<String, dynamic>;
      _rutinasAsignadas = decodedMap.map((key, value) => MapEntry(
          key, (jsonDecode(value) as List).map((e) => Rutina.fromJson(e)).toList()));
      notifyListeners();
    }
  }
}
