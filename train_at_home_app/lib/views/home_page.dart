import 'package:flutter/material.dart';
import 'package:trainathomeapp/views/profile_screen.dart';
import 'package:trainathomeapp/views/progress_screen.dart';
import 'package:trainathomeapp/views/routines_screens.dart';
import 'package:trainathomeapp/views/journal_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ProgressScreen(),
    RoutinesScreen(),
    JournalScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.indigo[900],
        unselectedItemColor: Colors.grey[300],
        selectedItemColor: Colors.greenAccent[400],
        
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Progreso'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Rutinas'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Planificador'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}



