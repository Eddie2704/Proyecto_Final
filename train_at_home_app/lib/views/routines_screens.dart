import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/providers/rutinas_provider.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rutinasProvider = Provider.of<RutinasProvider>(context);
    final rutinas = rutinasProvider.rutinas;
    return Scaffold(
      appBar: AppBar(
        title: Text('TrainAtHome'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey[300],
        
      ),
      // backgroundColor: Colors.grey[700],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,
          ),
          itemCount: rutinas.length,
          itemBuilder: (context, index) {
            final rutinaData = rutinas[index];
            final rutina = Rutina.fromJson(rutinaData);

            return Card(
              color: Colors.grey[550],
              elevation: 5,
              shadowColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rutina.name, //nombre de la rutina
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        // color: Colors.greenAccent[400],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      rutina.type, //tipo de rutina
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Tiempo de la rutina
                    Text(
                      'Duración: ${rutina.time} minutos',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    // Boton flotante para crear rutinas
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        
                        backgroundColor: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                          ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: rutina,
                        );
                      },
                      // Texto clickable para acceder a detalle de rutina
                      child: Text(
                        'Ver detalles',
                          style: TextStyle(
                              fontSize: 16, 
                              color: Colors.yellow[400], 
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent[400],
        onPressed: () => Navigator.pushNamed(context, '/createRoutine'),
        child: Icon(Icons.add, color: Colors.grey[900],),
        
      ),
    );
  }
}
