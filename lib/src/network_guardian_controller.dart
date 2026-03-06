// import 'dart:async';
// import 'internet_verifier.dart';
//
// class NetworkGuardianController {
//   // brain of our package
//   // ── private variables ──────────────────────────────────────────
//   //Singleton
//   static final NetworkGuardianController _instance =
//   NetworkGuardianController._internal();
//
//   factory NetworkGuardianController() => _instance;
//
//   NetworkGuardianController._internal();
//   // StreamController broadcasts internet status (true/false)
//   // broadcast() = multiple widgets can listen at same time
//   final StreamController<bool> _controller =
//       StreamController<bool>.broadcast();
//
//   Timer? _timer;                // periodic check timer
//   bool _lastStatus = true;      // tracks previous status
//   bool _isMonitoring = false;   // are we currently monitoring?
//
//   // ── public ─────────────────────────────────────────────────────
//
//   /// Stream that emits:
//   /// true  = internet available
//   /// false = internet lost
//   Stream<bool> get onStatusChange => _controller.stream;
//
//   /// Current monitoring state
//   bool get isMonitoring => _isMonitoring;
//
//   // ── methods ────────────────────────────────────────────────────
//
//   /// Call this to start monitoring internet connectivity
//   void startMonitoring({Duration interval = const Duration(seconds: 3)}) {
//
//     // prevent duplicate monitoring
//     if (_isMonitoring) return;
//     _isMonitoring = true;
//
//     // check immediately on start, dont wait 3 seconds
//     _checkInternet();
//
//     // then check every 3 seconds (or custom interval)
//     _timer = Timer.periodic(interval, (_) {
//       _checkInternet();
//     });
//   }
//
//   /// Call this to stop monitoring (important for memory!)
//   void stopMonitoring() {
//     _timer?.cancel();
//     _timer = null;
//     _isMonitoring = false;
//   }
//
//   /// Check internet and emit to stream only if status changed
//   Future<void> _checkInternet() async {
//     final bool hasInternet = await InternetVerifier.hasInternet();
//
//     // only emit if status actually changed
//     // this prevents unnecessary widget rebuilds
//     if (hasInternet != _lastStatus) {
//       _lastStatus = hasInternet;
//       _controller.add(hasInternet);
//     }
//   }
//
//   /// Always call dispose to free memory when done
//   void dispose() {
//     stopMonitoring();
//     _controller.close();
//   }
// }
//
//


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