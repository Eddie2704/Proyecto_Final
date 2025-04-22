import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late ConfettiController _confettiController; 

@override
void initState() {
  super.initState();
  _confettiController = ConfettiController(duration: const Duration(seconds: 5));

  final journal = Provider.of<JournalProvider>(context, listen: false);
  rutinasHoy = journal.rutinasAsignadas[_getToday()] ?? [];
  rutinaCompletada = List.generate(rutinasHoy.length, (_) => false);

  _cargarRutinasCompletadas();
  if (rutinasHoy.isNotEmpty) {
    temporizador = Provider.of<TemporizadorProvider>(context, listen: false);
    if (temporizador.isPaused) {
      temporizador.setDuration(Duration(minutes: rutinasHoy.first.time));
    }
    temporizador.addListener(() {
      if (temporizador.remaining.inSeconds == 0 && !temporizador.isPaused) {
        _marcarRutinaComoCompletada();
      }
    });
  }
}


  @override
  void dispose() {
    _confettiController.dispose();
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
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const WidgetTemporizador(),
                    const SizedBox(height: 8),
                     //boton no necesario
                    ElevatedButton.icon(
        onPressed: () {
          setState(() {
            rutinaCompletada = List.generate(rutinasHoy.length, (_) => true);
            rutinaActualIndex = rutinasHoy.length;
            _mostrarMensajeFinalizacion();
          });
        },
        icon: const Icon(Icons.celebration),
        label: const Text('Marcar todas como completadas'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.greenAccent[400],
          foregroundColor: Colors.black,
        ),
      ),
                    
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // ✅ Lista de rutinas del día con estado de cumplimiento
              Expanded(
                child: rutinasHoy.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: rutinasHoy.length,
                        itemBuilder: (_, index) {
                          final rutina = rutinasHoy[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.indigo.shade400, width: 1),),
                            color: Colors.grey[550],
                            child: ListTile(
                              title: Text(
                                rutina.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo[500]),
                              ),
                              subtitle: Text('${rutina.type} - ${rutina.time} min', style: TextStyle(color: Colors.grey[700])),
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

          // ✅ Confeti animado
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

  


  //Funciones
  void _marcarRutinaComoCompletada() async{
    if (rutinaActualIndex < rutinasHoy.length) {
      setState(() {
        rutinaCompletada[rutinaActualIndex] = true;
        rutinaActualIndex++;
        if (rutinaActualIndex < rutinasHoy.length) {
          temporizador.setDuration(Duration(minutes: rutinasHoy[rutinaActualIndex].time));
        } else {
          _mostrarMensajeFinalizacion();
        }
      });
      final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('rutinasCompletadas_${_getToday()}', rutinaCompletada.map((e) => e.toString()).toList());
    }
  }

  void _mostrarMensajeFinalizacion() {
    Vibration.vibrate(duration: 500);
    _confettiController.play();
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
  String _getToday() {
    final weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return weekdays[DateTime.now().weekday - 1];
  }

void _cargarRutinasCompletadas() async {
  final prefs = await SharedPreferences.getInstance();
  final rutinasGuardadas = prefs.getStringList('rutinasCompletadas_${_getToday()}') ?? [];
  if (rutinasHoy.isEmpty) return;
  setState(() {
    rutinaCompletada = List.generate(rutinasHoy.length, (index) {
      return index < rutinasGuardadas.length ? rutinasGuardadas[index] == 'true' : false;
    });
  });
}
}

