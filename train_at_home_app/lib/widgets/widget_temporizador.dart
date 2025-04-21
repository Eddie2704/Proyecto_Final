import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainathomeapp/providers/temporizador_provider.dart';

class WidgetTemporizador extends StatelessWidget {
  const WidgetTemporizador({super.key});

  @override
  Widget build(BuildContext context) {
    final temporizador = Provider.of<TemporizadorProvider>(context);

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
                temporizador.formattedTime,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent[400], // 🔹 Texto vibrante
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Botón dentro del Card
              ElevatedButton.icon(
                onPressed: () => _showTimePicker(context),
                icon: const Icon(Icons.timer),
                label: const Text('Ajustar tiempo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent[400], // 🔹 Botón verde neón
                  foregroundColor: Colors.black, // 🔹 Texto negro para contraste
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(temporizador.isRunning ? Icons.pause_circle_filled : Icons.play_circle_fill),
                    iconSize: 48,
                    color: Colors.greenAccent[400], // 🔹 Botón verde neón
                    onPressed: temporizador.isRunning ? temporizador.pausar : temporizador.iniciar,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.replay),
                    iconSize: 48,
                    color: Colors.orangeAccent[400], // 🔹 Botón naranja brillante
                    onPressed: temporizador.reiniciar,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) {
    int hours = 0, minutes = 0;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blueGrey[900], // 🔹 Fondo oscuro del selector
          child: Column(
            children: [
              Text(
                'Selecciona el tiempo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent[400]), // 🔹 Texto vibrante
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildPicker((val) => hours = val, 0, 23, 'h'),
                    _buildPicker((val) => minutes = val, 0, 59, 'm'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final total = Duration(hours: hours, minutes: minutes);
                  if (total.inSeconds > 0) {
                    Provider.of<TemporizadorProvider>(context, listen: false).setDuration(total);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent[400]), // 🔹 Botón naranja
                child: const Text('Aceptar', style: TextStyle(color: Colors.black)), // 🔹 Texto negro
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPicker(Function(int) onChanged, int min, int max, String label) {
    return Expanded(
      child: CupertinoPicker(
        itemExtent: 32,
        scrollController: FixedExtentScrollController(initialItem: 0),
        onSelectedItemChanged: onChanged,
        children: List.generate(max - min + 1, (index) {
          final val = min + index;
          return Center(
            child: Text(
              '$val $label',
              style: TextStyle(color: Colors.cyanAccent[400]), // 🔹 Texto vibrante
            ),
          );
        }),
      ),
    );
  }
}
