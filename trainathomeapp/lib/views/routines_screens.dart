// Pantalla de Rutinas
import 'package:flutter/material.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rutinas')),
      body: Center(child: Text('Listado de rutinas aquí')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/createRoutine'),
        child: Icon(Icons.add),
      ),
    );
  }
}
