import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated 3D gradient blobs floating behind content - Shiny Edition
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool blur;
  
  const AnimatedBackground({
    super.key,
    required this.child,
    this.blur = true,
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
      duration: const Duration(seconds: 25),
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
            // Animated gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppTheme.bgGradient,
                ),
              ),
            ),
            // 5 glowing blobs (more = richer)
            ...List.generate(5, (i) => _buildBlob(i)),
            // Subtle noise/twinkle layer
            ...List.generate(3, (i) => _buildTwinkle(i)),
            // Optional blur overlay for glass effect
            if (widget.blur)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(color: Colors.transparent),
                ),
              ),
            // Content
            child!,
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _buildBlob(int index) {
    final size = MediaQuery.of(context).size;
    final positions = [
      Offset(size.width * 0.08, size.height * 0.1),
      Offset(size.width * 0.78, size.height * 0.15),
      Offset(size.width * 0.5, size.height * 0.7),
      Offset(size.width * 0.02, size.height * 0.82),
      Offset(size.width * 0.85, size.height * 0.55),
    ];
    final sizes = [280.0, 320.0, 250.0, 300.0, 220.0];
    final colors = AppTheme.blobColors;

    final safeColors = List.generate(5, (i) => colors[i % colors.length]);

    final animValue = _controller.value;
    final phase = index * (pi * 2 / 5);
    final speed = 1.0 + index * 0.3;
    final sinOffset = sin((animValue * speed * pi * 2) + phase);
    final cosOffset = cos((animValue * speed * pi * 2) + phase * 0.7);

    return Positioned(
      left: positions[index].dx + (sinOffset * 40),
      top: positions[index].dy + (cosOffset * 35),
      child: Container(
        width: sizes[index],
        height: sizes[index],
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: Alignment(0.3, 0.3), // off-center for 3D feel
            colors: [
            safeColors[index].withValues(alpha: 0.35),
            safeColors[index].withValues(alpha: 0.08),
            safeColors[index].withValues(alpha: 0.0),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: safeColors[index].withValues(alpha: 0.25),
              blurRadius: 80,
              spreadRadius: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTwinkle(int index) {
    final size = MediaQuery.of(context).size;
    final phases = [0.0, 2.0, 4.0];
    final positions = [
      Offset(size.width * 0.3, size.height * 0.3),
      Offset(size.width * 0.65, size.height * 0.5),
      Offset(size.width * 0.15, size.height * 0.6),
    ];
    final colors = [AppTheme.warmCoral, AppTheme.cyanTeal, AppTheme.warmGold];
    
    final val = sin((_controller.value * pi * 4) + phases[index]);
    final opacity = ((val + 1) / 2) * 0.15; // pulse between 0 and 0.15

    return Positioned(
      left: positions[index].dx,
      top: positions[index].dy,
      child: Container(
        width: 4,
        height: 4,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colors[index].withValues(alpha: opacity),
          boxShadow: [
            BoxShadow(
              color: colors[index].withValues(alpha: opacity * 3),
              blurRadius: 12,
              spreadRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}
