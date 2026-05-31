import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated gradient blobs + twinkling stars — BIG, VISIBLE, ALIVE
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool showTwinkles;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.showTwinkles = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 28),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // ── Rich gradient base ──
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF120B1A),
                    Color(0xFF2A1848),
                    Color(0xFF1A1230),
                  ],
                ),
              ),
            ),
            // ── Large visible blobs ──
            _buildBlob(0), // top-left: amethyst
            _buildBlob(1), // top-right: rose gold
            _buildBlob(2), // center: coral
            _buildBlob(3), // bottom-left: teal
            _buildBlob(4), // bottom-right: gold
            // ── Twinkle dots ──
            if (widget.showTwinkles) ...[
              _buildTwinkle(0),
              _buildTwinkle(1),
              _buildTwinkle(2),
              _buildTwinkle(3),
            ],
            // ── Content ──
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _buildBlob(int index) {
    final size = MediaQuery.of(context).size;

    // Positions spread across the screen
    final positions = [
      Offset(size.width * 0.05, size.height * 0.08),
      Offset(size.width * 0.72, size.height * 0.12),
      Offset(size.width * 0.45, size.height * 0.65),
      Offset(size.width * -0.05, size.height * 0.78),
      Offset(size.width * 0.82, size.height * 0.48),
    ];

    // BIG blobs — 300 to 450px
    final sizes = [380.0, 420.0, 350.0, 400.0, 320.0];
    final colors = AppTheme.blobColors;
    final safeColors = List.generate(5, (i) => colors[i % colors.length]);

    final animValue = _controller.value;
    final phase = index * (pi * 2 / 5);
    final speed = 0.8 + index * 0.25;
    final sinOffset = sin((animValue * speed * pi * 2) + phase);
    final cosOffset = cos((animValue * speed * pi * 2) + phase * 0.7);

    return Positioned(
      left: positions[index].dx + (sinOffset * 50),
      top: positions[index].dy + (cosOffset * 40),
      child: Container(
        width: sizes[index],
        height: sizes[index],
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(0.3, 0.25),
            colors: [
              safeColors[index].withValues(alpha: 0.60),  // VISIBLE center glow
              safeColors[index].withValues(alpha: 0.18),  // mid
              safeColors[index].withValues(alpha: 0.0),   // edge
            ],
            stops: const [0.0, 0.45, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: safeColors[index].withValues(alpha: 0.40),
              blurRadius: 100,
              spreadRadius: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwinkle(int index) {
    final size = MediaQuery.of(context).size;
    final phases = [0.0, 2.5, 4.0, 1.2];
    final positions = [
      Offset(size.width * 0.25, size.height * 0.22),
      Offset(size.width * 0.70, size.height * 0.35),
      Offset(size.width * 0.15, size.height * 0.55),
      Offset(size.width * 0.55, size.height * 0.78),
    ];
    final colors = [
      AppTheme.roseGold,
      AppTheme.warmGold,
      AppTheme.primaryPurple,
      AppTheme.cyanTeal,
    ];

    final val = sin((_controller.value * pi * 4) + phases[index]);
    final opacity = ((val + 1) / 2) * 0.30; // pulse 0 to 0.30

    return Positioned(
      left: positions[index].dx,
      top: positions[index].dy,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[index].withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: colors[index].withValues(alpha: opacity * 4),
              blurRadius: 16,
              spreadRadius: 6,
            ),
          ],
        ),
      ),
    );
  }
}
