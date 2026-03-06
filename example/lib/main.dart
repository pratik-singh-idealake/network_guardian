import 'package:flutter/material.dart';
import 'package:network_guardian/network_guardian.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Guardian Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return NetworkGuardian(
          position: ToastPosition.top,
          toastDuration: const Duration(seconds: 5),
          child: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Guardian Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Network Guardian is watching! 👀',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Turn off your WiFi or mobile data\nto see the toast appear!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            const _StatusIndicator(),
          ],
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatefulWidget {
  const _StatusIndicator();

  @override
  State<_StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<_StatusIndicator> {
  // ✅ Singleton — same instance as NetworkGuardian widget
  final NetworkGuardianController _controller = NetworkGuardianController();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    // ✅ just listen — don't call startMonitoring() again
    // NetworkGuardian widget already started it!
    _controller.onStatusChange.listen((hasInternet) {
      if (!mounted) return;
      setState(() => _isOnline = hasInternet);
    });
  }

  @override
  void dispose() {
    // ✅ don't call _controller.dispose() here
    // NetworkGuardian widget owns the lifecycle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            _isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}