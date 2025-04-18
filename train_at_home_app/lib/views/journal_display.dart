import 'package:flutter/material.dart';

class JournalDisplay extends StatelessWidget {
  const JournalDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Planificador')),
      body: Center(child: Text('Calendario semanal aquí')),
    );
  }
}
