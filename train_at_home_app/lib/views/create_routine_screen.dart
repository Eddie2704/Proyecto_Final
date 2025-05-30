import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trainathomeapp/providers/rutinas_provider.dart';

class CreateRoutineScreen extends StatefulWidget {
   const CreateRoutineScreen({super.key});

  @override
  CreateRoutineScreenState createState() => CreateRoutineScreenState();
} 

class CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Map<String, dynamic>? _selectedRutina;
  
  final RutinasProvider rutinasProvider = RutinasProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Crear Nueva Rutina")),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            
            children: [
              
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration:  InputDecoration(labelText: 'Seleccionar Rutina Base'),
                items: rutinasProvider.rutinas.map((rutina) {
                  return DropdownMenuItem(
                    value: rutina,
                    child: Text('${rutina['name']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRutina = value;
                      _nameController.text = value['name'];
                      _typeController.text = value['type'];
                      _timeController.text = value['time'].toString();
                    });
                  }
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(labelText: 'Nombre de la Rutina'),
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration:  InputDecoration(labelText: 'Tipo de Rutina'),
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _timeController,
                decoration:  InputDecoration(labelText: 'Duración (minutos)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon:  Icon(Icons.save),
                label:  Text('Guardar'),
                  style: ElevatedButton.styleFrom(
                    padding:  EdgeInsets.symmetric(vertical: 14),
                    textStyle:  TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseFirestore.instance.collection('rutinas').add({
                          'name': _nameController.text,
                          'type': _typeController.text,
                          'time': int.parse(_timeController.text),
                          'ejercicios': _selectedRutina != null && _selectedRutina!['ejercicios'] != null
                              ? _selectedRutina!['ejercicios']
                              : [],
                          'userCreated': true,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Rutina guardada exitosamente')),
                        );
                        Navigator.pop(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al guardar rutina: $e')),
                        );
                      }
                    }
                  },
                ),

            ],
          ),
        ),
      ),
    );
  }
}
