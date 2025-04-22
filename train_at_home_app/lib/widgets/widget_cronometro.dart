import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainathomeapp/providers/cronometro_provider.dart';

class WidgetCronometro extends StatelessWidget {
  const WidgetCronometro({super.key});

  @override
  Widget build(BuildContext context) {
    final cronometro = Provider.of<CronometroProvider>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[550],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.indigoAccent.shade400, width: 1),
          ),
          child: Column(
            children: [
              Text(
                cronometro.formattedTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[400],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(cronometro.isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    iconSize: 48,
                    color: Colors.indigo[400], 
                    onPressed: cronometro.isRunning ? cronometro.pausar : cronometro.iniciar,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.replay),
                    iconSize: 48,
                    color: Colors.orangeAccent[400], // 🔹 Botón naranja brillante
                    onPressed: cronometro.reiniciar,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
