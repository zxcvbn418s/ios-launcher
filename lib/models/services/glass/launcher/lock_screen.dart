import 'package:flutter/material.dart';
import '../glass/liquid_glass.dart';

class LockScreen extends StatelessWidget {
  final VoidCallback onUnlock;

  const LockScreen({
    super.key,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onVerticalDragEnd: (_) => onUnlock(),
        child: Container(
          color: Colors.black.withOpacity(0.08),
          child: Column(
            children: [
              const SizedBox(height: 26),
              const Icon(
                Icons.lock_outline_rounded,
                color: Colors.white,
                size: 25,
              ),
              const SizedBox(height: 18),
              const Text(
                '09:41',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 82,
                  height: 0.95,
                  fontWeight: FontWeight.w200,
                  letterSpacing: -4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tuesday, June 30',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.82),
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LiquidGlass(
                  radius: 34,
                  blur: 24,
                  opacity: 0.14,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Swipe up or tap to unlock',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.90),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: onUnlock,
                child: Container(
                  width: 132,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
