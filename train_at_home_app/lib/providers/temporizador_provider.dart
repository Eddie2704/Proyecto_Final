import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class TemporizadorProvider extends ChangeNotifier {
  Duration _duration = const Duration(minutes: 1);
  Duration _remaining = const Duration(minutes: 1);
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = true;

  Duration get remaining => _remaining;
  String get formattedTime => '${_remaining.inMinutes}:${(_remaining.inSeconds % 60).toString().padLeft(2, '0')}';
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;

  TemporizadorProvider() {
    _loadProgress(); 
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt('remainingTime') ?? _duration.inSeconds;
    _remaining = Duration(seconds: seconds);
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('remainingTime', _remaining.inSeconds);
  }

  void setDuration(Duration duration) {
    _duration = duration;
    _remaining = duration;
    _isPaused = true;
    _saveProgress(); 
    notifyListeners();
  }

  void iniciar() {
    if (_isRunning || _remaining.inSeconds <= 0) return;

    _isRunning = true;
    _isPaused = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds > 0) {
        _remaining -= const Duration(seconds: 1);
        _saveProgress(); 
      } else {
        detener();
      }
      notifyListeners();
    });
  }

  void pausar() {
    if (!_isRunning) return;

    _timer?.cancel();
    _isRunning = false;
    _isPaused = true;
    _saveProgress(); 
    notifyListeners();
  }

  void reiniciar() {
    _timer?.cancel();
    _remaining = _duration;
    _isRunning = false;
    _isPaused = true;
    _saveProgress(); 
    notifyListeners();
  }

  void detener() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = true;
    _remaining = const Duration(seconds: 0);
    _saveProgress(); 
    notifyListeners();
  }
}
