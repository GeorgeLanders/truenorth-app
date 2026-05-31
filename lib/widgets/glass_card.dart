import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double radius;
  final double opacity;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? glowColor;
  final bool shiny;
  final Color? tint;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.height,
    this.width,
    this.radius = 18,
    this.opacity = 0.18,
    this.margin,
    this.borderColor,
    this.glowColor,
    this.shiny = true,
    this.tint,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveOpacity = opacity.clamp(0.05, 0.55);
    final bgColor = tint != null
        ? tint!.withValues(alpha: effectiveOpacity)
        : Colors.white.withValues(alpha: effectiveOpacity);
    final border = borderColor ?? tint?.withValues(alpha: 0.25) ?? Colors.white.withValues(alpha: 0.18);
    final glow = (glowColor ?? tint ?? AppTheme.primaryPurple);

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: glow.withValues(alpha: 0.12),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          children: [
            // Frosted glass base
            Positioned.fill(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(color: border, width: 1),
                  ),
                ),
              ),
            ),
            // Shiny gloss reflection at top
            if (shiny)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 45,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(radius),
                      topRight: Radius.circular(radius),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.14),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            // Content
            Padding(
              padding: padding ?? const EdgeInsets.all(16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
