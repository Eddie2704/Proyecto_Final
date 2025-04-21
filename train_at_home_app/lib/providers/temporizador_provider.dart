import 'dart:async';
import 'package:flutter/material.dart';

class TemporizadorProvider extends ChangeNotifier {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  Duration _duration = Duration.zero; 
  bool _isRunning = false;

  Duration get remaining => _remaining;
  Duration get duration => _duration;
  bool get isRunning => _isRunning;

  String get formattedTime {
    final hours = _remaining.inHours.toString().padLeft(2, '0');
    final minutes = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void setDuration(Duration duration) {
    _remaining = duration;
    _duration = duration;
    notifyListeners();
  }

  void iniciar() {
    if (_isRunning || _remaining.inSeconds <= 0) return;
    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining > Duration.zero) {
        _remaining -= const Duration(seconds: 1);
        notifyListeners();
      } else {
        _timer?.cancel();
        _isRunning = false;
        notifyListeners();
        
      }
    });
  }

  void pausar() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void reiniciar() {
    _timer?.cancel();
    _remaining = _duration;
    _remaining = Duration.zero;
    _isRunning = false;
    notifyListeners();




  }
}
