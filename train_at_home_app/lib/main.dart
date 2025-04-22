import 'package:flutter/material.dart';
//providers
import 'package:provider/provider.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/providers/cronometro_provider.dart';
import 'package:trainathomeapp/providers/journal_provider.dart';
import 'package:trainathomeapp/providers/rutinas_provider.dart';
import 'package:trainathomeapp/providers/temporizador_provider.dart';
//pantallas
import 'package:trainathomeapp/views/create_routine_screen.dart'; //pantalla Creacion de rutinas
import 'package:trainathomeapp/views/detalle_rutinas.dart'; // pantalla Detalle de rutinas
import 'package:trainathomeapp/views/home_page.dart'; // pantalla principal
import 'package:trainathomeapp/views/journal_screen.dart'; // pantalla Journal
import 'package:trainathomeapp/views/profile_screen.dart'; // pantalla Perfil
import 'package:trainathomeapp/views/progress_screen.dart'; // pantalla Progreso
import 'package:trainathomeapp/views/login_screen.dart'; // login
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trainathomeapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => RutinasProvider()),
      ChangeNotifierProvider(create: (_) => JournalProvider()),
      ChangeNotifierProvider(create: (_) => CronometroProvider()),
      ChangeNotifierProvider(create: (_) => TemporizadorProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrainAtHome',
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print("Snapshot connection state: ${snapshot.connectionState}");
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Depuración: Verifica el estado del snapshot
          if (snapshot.hasData) {
            print("User is logged in: ${snapshot.data?.email}");
            return const HomePage(); // Si está logueado, ir a HomePage
          } else {
            print("User is NOT logged in");
            return const LoginScreen(); // Si no está logueado, mostrar Login
          }
        },
      ),
      routes: {
        '/createRoutine': (context) => const CreateRoutineScreen(),
        '/progress': (context) => ProgressScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/journal': (context) => const JournalScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detalle') {
          final rutina = settings.arguments as Rutina;
          return MaterialPageRoute(
            builder: (context) => DetalleRutinas(rutina: rutina),
          );
        }

        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
  }
}
