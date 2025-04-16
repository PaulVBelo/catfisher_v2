import 'package:flutter/material.dart';

class BasicButton extends StatelessWidget {
  final Icon icon;
  final String tooltip;
  final VoidCallback onPressed;

  const BasicButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: icon, onPressed: onPressed, tooltip: tooltip);
  }
}
