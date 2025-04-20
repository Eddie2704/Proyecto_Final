import 'package:flutter/material.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/views/create_routine_screen.dart';
import 'package:trainathomeapp/views/detalle_rutinas.dart';
import 'package:trainathomeapp/views/home_page.dart';
import 'package:trainathomeapp/views/journal_display.dart';
import 'package:trainathomeapp/views/profile_screen.dart';
import 'package:trainathomeapp/views/progress_screen.dart'; // Asegúrate de importar Rutina

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainAtHome',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/detalle') {
          final rutina = settings.arguments as Rutina;
          return MaterialPageRoute(
            builder: (context) => DetalleRutinas(rutina: rutina),
          );
        }

        // Otras rutas estáticas
        final routes = {
          '/': (context) => const HomePage(),
          '/timer': (_) => TimerScreen(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
          '/progress': (context) =>  ProgressScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/journal': (context) => const JournalDisplay(),
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        // Ruta no encontrada
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
  }
}

// Temporizador / Cronómetro
class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temporizador')),
      body: Center(child: Text('Aquí va el temporizador / cronómetro')),
    );
  }
}
