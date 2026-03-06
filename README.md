# Network Guardian 🛡️

A lightweight Flutter package that monitors internet connectivity and
automatically shows a customizable toast notification when the connection
is lost — with zero configuration required.

---

## ✨ Features

- 🔍 **Real internet verification** — checks actual connectivity, not just WiFi/mobile status
- 🔔 **Auto toast notification** — shows when internet is lost, hides when restored
- 🎨 **Fully customizable** — bring your own toast widget
- 📍 **Position control** — show toast at top or bottom
- ⏱️ **Configurable duration** — control how long toast stays visible
- 🔋 **Battery optimized** — pauses monitoring when app is in background
- 📱 **Platform support** — Android & iOS

---

## 📦 Installation

Add to your `pubspec.yaml`:
```yaml
dependencies:
  network_guardian: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## ⚠️ Required Setup

### Android

Add permissions to `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application ...>
    </application>

</manifest>
```

### iOS

No additional setup required ✅

---

## 🚀 Quick Start

Wrap your `MaterialApp` using the `builder` parameter:
```dart
import 'package:network_guardian/network_guardian.dart';

MaterialApp(
  builder: (context, child) {
    return NetworkGuardian(
      child: child!,
    );
  },
  home: const HomeScreen(),
);
```

That's it! 🎉 Network Guardian will automatically monitor connectivity
and show a toast when internet is lost.

---

## 🎨 Customization

### Default Toast
Out of the box — no configuration needed:
```dart
NetworkGuardian(
  child: child!,
)
```

### Custom Toast Widget
Bring your own UI:
```dart
NetworkGuardian(
  customToast: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Row(
      children: [
        Icon(Icons.cloud_off, color: Colors.white),
        SizedBox(width: 8),
        Text(
          'No Internet!',
          style: TextStyle(color: Colors.white),
        ),
      ],
    ),
  ),
  child: child!,
)
```

### Toast Position
Show at top or bottom of screen:
```dart
// top (default)
NetworkGuardian(
  position: ToastPosition.top,
  child: child!,
)

// bottom
NetworkGuardian(
  position: ToastPosition.bottom,
  child: child!,
)
```

### Custom Duration
Control how long toast stays visible:
```dart
NetworkGuardian(
  toastDuration: const Duration(seconds: 6),
  child: child!,
)
```

---

## 📡 Listen to Connectivity Changes

Use `NetworkGuardianController` to react to connectivity changes anywhere in your app:
```dart
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final NetworkGuardianController _controller = NetworkGuardianController();
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    // just listen — NetworkGuardian already handles monitoring
    _controller.onStatusChange.listen((hasInternet) {
      if (!mounted) return;
      setState(() => _isOnline = hasInternet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_isOnline ? 'Online ✅' : 'Offline ❌');
  }
}
```

---

## 📋 API Reference

### `NetworkGuardian`

| Parameter | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | required | Your app or screen widget |
| `customToast` | `Widget?` | null | Custom toast widget |
| `position` | `ToastPosition` | `top` | Toast position on screen |
| `toastDuration` | `Duration` | 4 seconds | How long toast is visible |

### `ToastPosition`

| Value | Description |
|---|---|
| `ToastPosition.top` | Show toast at top of screen |
| `ToastPosition.bottom` | Show toast at bottom of screen |

### `NetworkGuardianController`

| Member | Type | Description |
|---|---|---|
| `onStatusChange` | `Stream<bool>` | Emits true/false on connectivity change |
| `isMonitoring` | `bool` | Whether monitoring is active |
| `startMonitoring()` | `void` | Start connectivity monitoring |
| `pauseMonitoring()` | `void` | Pause monitoring (background) |
| `resumeMonitoring()` | `void` | Resume monitoring (foreground) |
| `stopMonitoring()` | `void` | Stop monitoring completely |

---

## 💡 How It Works
```
App running
    ↓
NetworkGuardian checks internet every 3 seconds
    ↓
Performs real HTTP check (not just WiFi status)
    ↓
Internet lost → toast slides in automatically
    ↓
Internet restored → toast slides out automatically
    ↓
App goes to background → monitoring pauses (saves battery)
    ↓
App comes to foreground → monitoring resumes
```

---

## 🔮 Upcoming Features

- 🪟 Windows support
- 🐧 Linux support
- 🔄 Auto retry failed API calls
- 📥 Offline request queue
- ⚡ Native platform channels (zero polling)
- 🔌 Dio interceptor
- 🔌 Chopper interceptor

---

## 🐛 Known Limitations

- Checks connectivity every 3 seconds (polling based)
- Native event-based detection coming in v0.1.0

---

## 🤝 Contributing

Contributions are welcome!
Please open an issue or submit a PR on GitHub.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 👨‍💻 Author

Made with ❤️ by Pratik Singh