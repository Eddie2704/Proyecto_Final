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
      'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
      return Scaffold(
      appBar: AppBar(
        title: Text('Mi semana'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.grey[300],
      ),
      body: ListView.builder(
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final dia = dias[index];
          final rutinas = rutinasAsignadas[dia] ?? [];
          return Card(
            color: Colors.grey[550],
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.indigo.shade400, width: 1),
            ),
            child: ListTile(
              title: Text(dia),
              subtitle: rutinas.isNotEmpty
                  ? Text(rutinas.map((r) => r.name).join(", "))
                  : Text('Sin rutinas asignadas'),
              trailing: IconButton(
                icon: Icon(Icons.add),
                color: Colors.greenAccent[400],
                //Añadir rutinas a los dias
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) {
                    return Padding(
                      padding: EdgeInsets.all(12),
                      child: ListView.separated(
                      itemCount: rutinasDisponibles.length,
                        separatorBuilder: (_, __) => Divider(color: Colors.grey, thickness: 0.5), 
                        itemBuilder: (_, index) {
                        final r = rutinasDisponibles[index];
                        //muestra las rutinas disponibles
                        return  GestureDetector( 
                        onTap: () { 
                          context.read<JournalProvider>().asignarRutina(dia, r);
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:  Colors.grey[550], 
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.indigo.shade400, width: 1),
                          ),
                          margin:  EdgeInsets.symmetric(vertical: 8), 
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[500]),
                              ),
                              Text(
                                '${r.type} - ${r.time} min',
                                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                    },
                  ),
                ),
              );
            },
          ),
          //Boton para eliminar rutinas de los dias
          floatingActionButton: FloatingActionButton(
    backgroundColor: Colors.yellow[400],
    foregroundColor: Colors.black,
    child: Icon(Icons.delete),
    onPressed: () {
      showModalBottomSheet(
    context: context,
    builder: (_) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Expanded( 
            child: ListView(
              children: dias.map((dia) {
                final rutinas = rutinasAsignadas[dia] ?? [];
                return rutinas.isNotEmpty
                    ? ExpansionTile(
                        title: Text(dia),
                        children: [
                          ...rutinas.map((r) => ListTile(
                                title: Text(r.name),
                                subtitle: Text('${r.type} - ${r.time} min'),
                                trailing: Icon(Icons.delete, color: Colors.red),
                                onTap: () {
                                  context.read<JournalProvider>().quitarRutina(dia, r);
                                  Navigator.pop(context);
                                },
                              )),
                          Divider(),
                          TextButton(
                            onPressed: () {
                              context.read<JournalProvider>().borrarTodasRutinas(dia);
                              Navigator.pop(context);
                            },
                            child:Text("Eliminar todas en este día", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    :SizedBox();
              }).toList(),
            ),
          ),
           Divider(), //Separador entre la lista y el botón
          //Botón  abajo para eliminar las rutinas de Todos los días
          TextButton(
            onPressed: () {
              context.read<JournalProvider>().borrarTodasLasRutinasDeTodosLosDias();
              Navigator.pop(context);
            },
            child: Text(
              "Eliminar todas las rutinas",
              style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      );
    },
  );
}
),

    );
  }
}