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
import 'package:trainathomeapp/views/cronometro_screen.dart';
import 'package:trainathomeapp/views/detalle_rutinas.dart'; // pantalla Detalle de rutinas
import 'package:trainathomeapp/views/home_page.dart'; // pantalla principal
import 'package:trainathomeapp/views/journal_screen.dart'; // pantalla Journal
import 'package:trainathomeapp/views/profile_screen.dart'; // pantalla Perfil
import 'package:trainathomeapp/views/progress_screen.dart'; // pantalla Progreso
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:trainathomeapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RutinasProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
        ChangeNotifierProvider(create: (_) => CronometroProvider()),
        ChangeNotifierProvider(create: (_) => TemporizadorProvider()),
      ],
      child:  MyApp(),
    ),);
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
          '/': (context) =>  HomePage(),
          '/createRoutine': (context) =>  CreateRoutineScreen(),
          '/progress': (context) =>  ProgressScreen(),
          '/profile': (context) =>  ProfileScreen(),
          '/cronometro': (context) =>  CronometroScreen(),
          '/journal': (context) =>  JournalScreen()
          
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        // Ruta no encontrada
        return MaterialPageRoute(
          builder: (context) =>  Scaffold(
            body: Center(child: Text('Ruta no encontrada')),
          ),
        );
      },
    );
  }
}


