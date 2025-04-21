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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blueGrey[900], // 🔹 Fondo oscuro elegante
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey[600]!.withOpacity(0.5), blurRadius: 8, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              Text(
                cronometro.formattedTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent[400], // 🔹 Texto vibrante
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(cronometro.isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    iconSize: 48,
                    color: Colors.greenAccent[400], // 🔹 Botón verde neón
                    onPressed: cronometro.isRunning ? cronometro.pausar : cronometro.iniciar,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.replay),
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
