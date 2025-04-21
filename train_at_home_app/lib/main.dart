import 'package:flutter/material.dart';
//providers
import 'package:provider/provider.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/providers/journal_provider.dart';
import 'package:trainathomeapp/providers/rutinas_provider.dart';
//pantallas
import 'package:trainathomeapp/views/create_routine_screen.dart';
import 'package:trainathomeapp/views/detalle_rutinas.dart';
import 'package:trainathomeapp/views/home_page.dart';
import 'package:trainathomeapp/views/journal_screen.dart';
import 'package:trainathomeapp/views/profile_screen.dart';
import 'package:trainathomeapp/views/progress_screen.dart'; 
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:trainathomeapp/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RutinasProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
      ],
      child: const MyApp(),
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
          '/': (context) => const HomePage(),
          '/createRoutine': (context) => const CreateRoutineScreen(),
          '/progress': (context) =>  ProgressScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/journal': (context) => const JournalScreen(),
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


