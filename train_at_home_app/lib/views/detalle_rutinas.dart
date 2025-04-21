
import 'package:flutter/material.dart';
import 'package:trainathomeapp/models/rutinas.dart';

class DetalleRutinas extends StatelessWidget {
  final Rutina rutina;

  const DetalleRutinas(
          {Key? key, required this.rutina} ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(rutina.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipo: ${rutina.type}', 
                  style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Duración: ${rutina.time} minutos', 
                  style: const TextStyle(
                          fontSize: 18)
            ),
            const SizedBox(height: 20),
            Text('Ejercicios recomendados:', 
                  style: const TextStyle(fontSize: 20, 
                  fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), 
              itemCount: rutina.ejercicios.length,
              itemBuilder: (context, index) {
                final ejercicio = rutina.ejercicios[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                        leading: const Icon(Icons.fitness_center, 
                                  color: Colors.blueAccent),
                        title: Text(
                              ejercicio['nombre'] ?? 'Ejercicio',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Repeticiones: ${ejercicio['repeticiones']}'),
                    ),
                  );
              },
            ),],
        ),
      ),
    );
  }
}
