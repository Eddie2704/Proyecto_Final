import 'package:flutter/material.dart';
import 'package:trainathomeapp/widgets/widget_temporizador.dart';
import 'package:trainathomeapp/widgets/widget_cronometro.dart';

class CronometroScreen extends StatelessWidget {
  const CronometroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cronómetro y Temporizador'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.grey[300],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Temporizador',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            WidgetTemporizador(),
            SizedBox(height: 30),
            Text(
              'Cronómetro',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            WidgetCronometro(),
          ],
        ),
      ),
    );
  }
}
