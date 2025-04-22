import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart'; 
import 'package:confetti/confetti.dart'; 
import 'package:trainathomeapp/providers/journal_provider.dart';
import 'package:trainathomeapp/providers/temporizador_provider.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/widgets/widget_temporizador.dart'; 

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  late TemporizadorProvider temporizador;
  late List<Rutina> rutinasHoy;
  int rutinaActualIndex = 0;
  List<bool> rutinaCompletada = [];
  late ConfettiController _confettiController; //  Controlador de confeti

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2)); //  Inicializa confeti

    final journal = Provider.of<JournalProvider>(context, listen: false);
    rutinasHoy = journal.rutinasAsignadas[_getToday()] ?? [];
    rutinaCompletada = List.generate(rutinasHoy.length, (_) => false);

    if (rutinasHoy.isNotEmpty) {
      temporizador = Provider.of<TemporizadorProvider>(context, listen: false);
      temporizador.setDuration(Duration(minutes: rutinasHoy.first.time));
      temporizador.iniciar();

      temporizador.addListener(() {
        if (temporizador.remaining.inSeconds == 0) {
          _marcarRutinaComoCompletada();
        }
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose(); // Libera recursos del confeti
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progreso de ${_getToday()}'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.grey[300],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 8),

              // Temporizador compacto al inicio con botón de reinicio 
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const WidgetTemporizador(),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _reiniciarRutinaActual,
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Reiniciar rutina actual'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent[400],
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              //  Lista de rutinas del día con estado de cumplimiento
              Expanded(
                child: rutinasHoy.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: rutinasHoy.length,
                        itemBuilder: (_, index) {
                          final rutina = rutinasHoy[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: Colors.blueGrey[900],
                            child: ListTile(
                              title: Text(
                                rutina.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyanAccent[400]),
                              ),
                              subtitle: Text('${rutina.type} - ${rutina.time} min', style: TextStyle(color: Colors.grey[400])),
                              trailing: rutinaCompletada[index]
                                  ? const Icon(Icons.check_circle, color: Colors.greenAccent, size: 28)
                                  : const Icon(Icons.timer, color: Colors.orangeAccent, size: 28),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No hay rutinas planificadas para hoy',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),

          //  Confeti animado
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [Colors.greenAccent, Colors.orangeAccent, Colors.cyanAccent],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Marca la rutina actual como completada y avanza a la siguiente
  void _marcarRutinaComoCompletada() {
    if (rutinaActualIndex < rutinasHoy.length) {
      setState(() {
        rutinaCompletada[rutinaActualIndex] = true;
        rutinaActualIndex++;

        if (rutinaActualIndex < rutinasHoy.length) {
          temporizador.setDuration(Duration(minutes: rutinasHoy[rutinaActualIndex].time));
          temporizador.iniciar();
        } else {
          _mostrarMensajeFinalizacion();
        }
      });
    }
  }

  //  Reinicia Solo la rutina actual sin avanzar a la siguiente
  void _reiniciarRutinaActual() {
    if (rutinaActualIndex < rutinasHoy.length) {
      setState(() {
        temporizador.setDuration(Duration(minutes: rutinasHoy[rutinaActualIndex].time));
        temporizador.iniciar();
      });
    }
  }

  // Vibración y confeti cuando todas las rutinas se completan
  void _mostrarMensajeFinalizacion() {
    Vibration.vibrate(duration: 500); // ✅ Activa la vibración
    _confettiController.play(); // ✅ Activa confeti

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¡Rutinas completadas!'),
        content: const Text('Has finalizado todas las rutinas del día. 🎉'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  //Obtiene el día actual en español
  String _getToday() {
    final weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return weekdays[DateTime.now().weekday - 1];
  }
}
