// Seguimiento de Progreso
import 'package:flutter/material.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Progreso')),
      body: Center(child: Text('Gráficas y estadísticas aquí')),
    );
  }
}