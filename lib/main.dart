import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const IOSLauncherApp());
}

class IOSLauncherApp extends StatelessWidget {
  const IOSLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'iOS Launcher Liquid Glass',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: const MainContainer(),
    );
  }
}

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  bool isLocked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // والپیپر تاریک نئونی و باکیفیت برای جلوه بهتر شیشه‌ها
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe',
              fit: BoxFit.cover,
            ),
          ),
          isLocked
              ? LockScreen(onUnlock: () => setState(() => isLocked = false))
              : const HomeScreen(),
        ],
      ),
    );
  }
}

class LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;
  const LockScreen({super.key, required this.onUnlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Icon(Icons.lock_outline, color: Colors.white, size: 30),
            const SizedBox(height: 16),
            const Text(
              '09:41',
              style: TextStyle(fontSize: 84, fontWeight: FontWeight.w200, color: Colors.white, letterSpacing: -2),
            ),
            const Text(
              'Sunday, June 28',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: Colors.white70),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onUnlock,
              child: Container(
                margin: const EdgeInsets.only(bottom: 60),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Tap to Unlock ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
