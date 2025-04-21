import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainathomeapp/models/rutinas.dart';
import 'package:trainathomeapp/providers/journal_provider.dart';
import 'package:trainathomeapp/providers/rutinas_provider.dart';


class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rutinasProvider = Provider.of<RutinasProvider>(context);
    final rutinasDisponibles = rutinasProvider.rutinas.map((r) => Rutina.fromJson(r)).toList();
    final rutinasAsignadas = context.watch<JournalProvider>().rutinasAsignadas;

    final dias = [
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi semana'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.grey[300],
      ),
      body: ListView.builder(
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final dia = dias[index];
          final rutina = rutinasAsignadas[dia];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(dia),
              subtitle: Text(rutina?.name ?? 'Sin rutina asignada'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return ListView(
                        children: rutinasDisponibles.map((r) {
                          return ListTile(
                            title: Text(r.name),
                            subtitle: Text('${r.type} - ${r.time} min'),
                            onTap: () {
                              context.read<JournalProvider>().asignarRutina(dia, r);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
              onLongPress: rutina != null
                  ? () => context.read<JournalProvider>().quitarRutina(dia)
                  : null,
            ),
          );
        },
      ),
    );
  }

}

