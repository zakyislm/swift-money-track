import 'package:flutter/material.dart';

class NeoCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String variant;
  final double borderWidth;
  final double shadowOffset;
  final Color shadowColor;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const NeoCard({
    Key? key,
    required this.child,
    this.variant = 'surface',
    this.backgroundColor,
    this.borderWidth = 3.0,
    this.shadowOffset = 4.0,
    this.shadowColor = Colors.black,
    this.padding,
    this.borderRadius = 0.0,
  }) : super(key: key);

  Color getVariantColor() {
    if (backgroundColor != null) return backgroundColor!;
    switch (variant) {
      case 'yellow':
        return const Color(0xFFFFE600);
      case 'green':
        return const Color(0xFF2DE17F);
      case 'pink':
        return const Color(0xFFFF2E93);
      case 'bright':
        return const Color(0xFFFFE600);
      case 'white':
        return Colors.white;
      case 'dark':
        return const Color(0xFF1E2122);
      case 'surface':
      default:
        return const Color(0xFF1C1E1F);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getVariantColor();

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 0.0,
            spreadRadius: 0.0,
            offset: Offset(shadowOffset, shadowOffset),
          ),
        ],
      ),
      padding: padding ?? const EdgeInsets.all(16.0),
      child: child,
    );
  }
}
