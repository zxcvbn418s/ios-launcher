import 'package:flutter/material.dart';
import 'launcher/home_screen.dart';
import 'launcher/lock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const IOSLauncherApp());
}

class IOSLauncherApp extends StatelessWidget {
  const IOSLauncherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS 26 Launcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const LauncherRoot(),
    );
  }
}

class LauncherRoot extends StatefulWidget {
  const LauncherRoot({super.key});

  @override
  State<LauncherRoot> createState() => _LauncherRootState();
}

class _LauncherRootState extends State<LauncherRoot> {
  bool locked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _LauncherWallpaper(),
          if (locked)
            LockScreen(
              onUnlock: () {
                setState(() {
                  locked = false;
                });
              },
            )
          else
            const HomeScreen(),
        ],
      ),
    );
  }
}

class _LauncherWallpaper extends StatelessWidget {
  const _LauncherWallpaper();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFDAF7FF),
                  Color(0xFF192F45),
                  Color(0xFF080C18),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: -80,
          top: 40,
          child: _GlowCircle(
            size: 280,
            color: Color(0x99FFFFFF),
          ),
        ),
        Positioned(
          right: -110,
          top: 140,
          child: _GlowCircle(
            size: 320,
            color: Color(0x6634E6FF),
          ),
        ),
        Positioned(
          left: 40,
          bottom: 60,
          child: _GlowCircle(
            size: 260,
            color: Color(0x66A855FF),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: _GlassPatternPainter(),
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 90,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.045)
      ..strokeWidth = 1;

    for (double i = -size.height; i < size.width; i += 58) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        linePaint,
      );
    }

    for (double i = 0; i < size.width + size.height; i += 74) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
