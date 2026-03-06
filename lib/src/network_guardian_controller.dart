
import 'dart:async';
import 'internet_verifier.dart';

class NetworkGuardianController {

  // ── Singleton ─────────────────────────────────────────────────
  static final NetworkGuardianController _instance =
  NetworkGuardianController._internal();

  factory NetworkGuardianController() => _instance;

  NetworkGuardianController._internal();

  // ── private variables ─────────────────────────────────────────
  final StreamController<bool> _controller =
  StreamController<bool>.broadcast();

  Timer? _timer;
  bool _lastStatus = true;
  bool _isMonitoring = false;
  Duration _interval = const Duration(seconds: 3);

  // ── public ────────────────────────────────────────────────────

  Stream<bool> get onStatusChange => _controller.stream;
  bool get isMonitoring => _isMonitoring;

  // ── methods ───────────────────────────────────────────────────

  void startMonitoring({
    Duration interval = const Duration(seconds: 3),
  }) {
    if (_isMonitoring) return;
    _interval = interval;
    _isMonitoring = true;
    _checkInternet();
    _startTimer();
  }

  // pause timer only — keeps _isMonitoring true
  void pauseMonitoring() {
    _stopTimer();
  }

  // resume — check immediately then restart timer
  void resumeMonitoring() {
    if (!_isMonitoring) return;
    _checkInternet();
    _startTimer();
  }

  void stopMonitoring() {
    _stopTimer();
    _isMonitoring = false;
  }

  void _startTimer() {
    _stopTimer();
    _timer = Timer.periodic(_interval, (_) {
      _checkInternet();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _checkInternet() async {
    final bool hasInternet = await InternetVerifier.hasInternet();
    if (hasInternet != _lastStatus) {
      _lastStatus = hasInternet;
      _controller.add(hasInternet);
    }
  }

  void dispose() {
    stopMonitoring();
    _controller.close();
  }
}