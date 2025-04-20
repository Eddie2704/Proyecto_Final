import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController cardioPointsController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedGender = 'Hombre';

  TimeOfDay? bedTime;
  TimeOfDay? wakeTime;
  bool sleepTrackingEnabled = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cardioPointsController.text = prefs.getString('cardioPoints') ?? '';
      birthDateController.text = prefs.getString('birthDate') ?? '';
      heightController.text = prefs.getString('height') ?? '';
      weightController.text = prefs.getString('weight') ?? '';
      selectedGender = prefs.getString('gender') ?? 'Hombre';

      final bedTimeStr = prefs.getString('bedTime');
      final wakeTimeStr = prefs.getString('wakeTime');
      if (bedTimeStr != null && wakeTimeStr != null) {
        bedTime = TimeOfDayExtension.fromString(bedTimeStr);
        wakeTime = TimeOfDayExtension.fromString(wakeTimeStr);
        sleepTrackingEnabled = true;
      }
    });
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardioPoints', cardioPointsController.text);
    await prefs.setString('birthDate', birthDateController.text);
    await prefs.setString('height', heightController.text);
    await prefs.setString('weight', weightController.text);
    await prefs.setString('gender', selectedGender);

    if (sleepTrackingEnabled && bedTime != null && wakeTime != null) {
      await prefs.setString('bedTime', bedTime!.format(context));
      await prefs.setString('wakeTime', wakeTime!.format(context));
    } else {
      await prefs.remove('bedTime');
      await prefs.remove('wakeTime');
    }
  }

  Widget buildCard({required IconData icon, required String title, required List<Widget> children}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType? type, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        keyboardType: type,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Future<void> selectTime({required bool isBedTime}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) {
          bedTime = picked;
        } else {
          wakeTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                user?.displayName ?? 'Usuario',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user?.photoURL ?? ''),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildCard(
              icon: Icons.fitness_center,
              title: 'Actividad Física',
              children: [
                buildTextField(
                  'Puntos Cardio',
                  cardioPointsController,
                  type: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
            buildCard(
              icon: Icons.bedtime,
              title: 'Sueño',
              children: [
                SwitchListTile(
                  title: const Text('Seguimiento del sueño'),
                  value: sleepTrackingEnabled,
                  onChanged: (value) => setState(() => sleepTrackingEnabled = value),
                ),
                if (sleepTrackingEnabled) ...[
                  ListTile(
                    title: const Text('Hora de acostarse'),
                    subtitle: Text(bedTime != null ? bedTime!.format(context) : 'No seleccionada'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => selectTime(isBedTime: true),
                  ),
                  ListTile(
                    title: const Text('Hora de despertarse'),
                    subtitle: Text(wakeTime != null ? wakeTime!.format(context) : 'No seleccionada'),
                    trailing: const Icon(Icons.access_time),
                    onTap: () => selectTime(isBedTime: false),
                  ),
                ]
              ],
            ),
            buildCard(
              icon: Icons.person,
              title: 'Datos Personales',
              children: [
                buildTextField(
                  'Fecha de nacimiento',
                  birthDateController,
                  type: TextInputType.datetime,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9./-]'))],
                ),
                buildTextField(
                  'Altura (cm)',
                  heightController,
                  type: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                ),
                buildTextField(
                  'Peso (Lbs)',
                  weightController,
                  type: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Género',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedGender,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: ['Hombre', 'Mujer']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              onPressed: () async {
                await saveUserData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos guardados')),
                );
              },
              label: const Text('Guardar'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  static TimeOfDay fromString(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}

