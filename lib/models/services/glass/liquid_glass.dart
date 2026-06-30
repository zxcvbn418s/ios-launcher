import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlass extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final Color? borderColor;
  final List<BoxShadow>? shadows;

  const LiquidGlass({
    super.key,
    required this.child,
    this.radius = 28,
    this.blur = 24,
    this.opacity = 0.16,
    this.padding = EdgeInsets.zero,
    this.gradient,
    this.borderColor,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: const Color(0xFF58F4FF).withOpacity(0.14),
                blurRadius: 26,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: Colors.white.withOpacity(opacity),
              gradient: gradient ??
                  LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.32),
                      Colors.white.withOpacity(0.08),
                      const Color(0xFF4DF7FF).withOpacity(0.10),
                    ],
                  ),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.30),
                width: 1.2,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 10,
                  top: 8,
                  right: 10,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.75),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                  ),
                ),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color accent;

  const GlassButton({
    super.key,
    required this.icon,
    this.onTap,
    this.accent = const Color(0xFF7A5CFF),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: LiquidGlass(
        radius: 22,
        blur: 18,
        opacity: 0.18,
        padding: const EdgeInsets.all(13),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.42),
            accent.withOpacity(0.24),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}
