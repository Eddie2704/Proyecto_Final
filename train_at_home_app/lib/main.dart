import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trainathomeapp/views/home_page.dart';
import 'package:trainathomeapp/views/journal_display.dart';
import 'package:trainathomeapp/views/profile_screen.dart';
import 'package:trainathomeapp/views/progress_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Initializar Firebase
  WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainAtHome',
      //home: MainPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/routineDetail': (_) => RoutineDetailScreen(),
        '/timer': (_) => TimerScreen(),
        '/createRoutine': (_) => CreateRoutineScreen(),
        '/progress': (_) => ProgressScreen(),
        '/profile': (_) => ProfileScreen(),
        '/journal': (_) => JournalDisplay(),
      },
    );
  }
}




// Detalle de Rutina
class RoutineDetailScreen extends StatelessWidget {
  const RoutineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Rutina')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ejercicios de la rutina'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/timer'),
              child: Text('Iniciar Temporizador'),
            ),
          ],
        ),
      ),
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

// Crear Nueva Rutina
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
