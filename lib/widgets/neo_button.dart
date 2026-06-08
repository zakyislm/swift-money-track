import 'package:flutter/material.dart';

class NeoButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String variant;
  final Color? backgroundColor;
  final double borderWidth;
  final double shadowOffset;
  final Color shadowColor;
  final EdgeInsetsGeometry? padding;

  const NeoButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.variant = 'white',
    this.backgroundColor,
    this.borderWidth = 3.0,
    this.shadowOffset = 4.0,
    this.shadowColor = Colors.black,
    this.padding,
  }) : super(key: key);

  @override
  State<NeoButton> createState() => _NeoButtonState();
}

class _NeoButtonState extends State<NeoButton> {
  bool _isPressed = false;

  Color getVariantColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    switch (widget.variant) {
      case 'yellow':
        return const Color(0xFFFFE600);
      case 'green':
        return const Color(0xFF2DE17F);
      case 'pink':
        return const Color(0xFFFF2E93);
      case 'dark':
        return const Color(0xFF1E2122);
      case 'gray':
        return const Color(0xFF2C3234);
      case 'white':
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = getVariantColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(
          _isPressed ? widget.shadowOffset : 0,
          _isPressed ? widget.shadowOffset : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: Colors.black,
            width: widget.borderWidth,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                    offset: Offset(widget.shadowOffset, widget.shadowOffset),
                  ),
                ],
        ),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: widget.child,
      ),
    );
  }
}
