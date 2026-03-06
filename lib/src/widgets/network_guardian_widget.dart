import 'dart:async';
import 'package:flutter/material.dart';
import '../network_guardian_controller.dart';
import 'default_toast.dart';

class NetworkGuardian extends StatefulWidget {
  final Widget child;
  final Widget? customToast;
  final ToastPosition position;
  final Duration toastDuration;

  const NetworkGuardian({
    super.key,
    required this.child,
    this.customToast,
    this.position = ToastPosition.top,
    this.toastDuration = const Duration(seconds: 4),
  });

  @override
  State<NetworkGuardian> createState() => _NetworkGuardianState();
}

class _NetworkGuardianState extends State<NetworkGuardian>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  final NetworkGuardianController _controller = NetworkGuardianController();
  StreamSubscription<bool>? _subscription;

  final GlobalKey<OverlayState> _overlayKey = GlobalKey<OverlayState>();

  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  Timer? _hideTimer;
  bool _isToastVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _controller.dispose();
    _animationController.dispose();
    _hideTimer?.cancel();
    _removeOverlay();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _controller.resumeMonitoring();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        _controller.pauseMonitoring();
        break;
      case AppLifecycleState.detached:
        _controller.stopMonitoring();
        break;
    }
  }

  void _startListening() {
    _subscription = _controller.onStatusChange.listen((bool hasInternet) {
      if (!mounted) return;
      if (!hasInternet) {
        _showToast();
      } else {
        _hideToast();
      }
    });
    _controller.startMonitoring();
  }

  void _showToast() {
    if (!mounted) return;
    if (_isToastVisible) return;
    _isToastVisible = true;
    _hideTimer?.cancel();
    _removeOverlay();

    final overlayState = _overlayKey.currentState;
    if (overlayState == null) {
      _isToastVisible = false;
      return;
    }

    _overlayEntry = _buildOverlayEntry();
    overlayState.insert(_overlayEntry!);
    _animationController.forward(from: 0);

    _hideTimer = Timer(widget.toastDuration, () {
      _hideToast();
    });
  }

  void _hideToast() {
    _hideTimer?.cancel();
    if (!_isToastVisible) return;
    _isToastVisible = false;
    _animationController.reverse().then((_) {
      _removeOverlay();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _buildOverlayEntry() {
    final isTop = widget.position == ToastPosition.top;

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, isTop ? -1 : 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    return OverlayEntry(
      builder: (context) => Positioned(
        top: isTop ? 50 : null,
        bottom: isTop ? null : 50,
        left: 16,
        right: 16,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.customToast ?? const DefaultToast(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // completely independent from Navigator
    // always has overlay context
    return Overlay(
      key: _overlayKey,
      initialEntries: [
        OverlayEntry(
          builder: (context) => widget.child,
        ),
      ],
    );
  }
}

enum ToastPosition { top, bottom }