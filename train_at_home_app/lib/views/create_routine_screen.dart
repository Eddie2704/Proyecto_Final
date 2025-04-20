import 'package:flutter/material.dart';

class CreateRoutineScreen extends StatelessWidget {
  const CreateRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Rutina')),
      body: Center(child: Text('Formulario para crear rutina')),
    );
  }
}