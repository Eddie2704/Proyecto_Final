import 'dart:async';
import 'package:flutter/material.dart';

class CronometroProvider extends ChangeNotifier {
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _formattedTime = '00:00:00';

  CronometroProvider() {
    _stopwatch = Stopwatch(); 
  }

  String get formattedTime => _formattedTime;
  bool get isRunning => _stopwatch.isRunning;

  void iniciar() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _formattedTime = _formatDuration(_stopwatch.elapsed);
        notifyListeners();
      });
    }
  }

  void pausar() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer.cancel();
      notifyListeners();
    }
  }

  void reiniciar() {
    _stopwatch.reset();
    _formattedTime = '00:00:00';
    notifyListeners();
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
