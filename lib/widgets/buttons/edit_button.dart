import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    this.size,
    required this.message,
    required this.onPressed,
    this.color,
    this.altIcon,
    super.key,
  });

  final double? size;
  final String? message;
  final Color? color;
  final IconData? altIcon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: SizedBox(
        height: size ?? 25,
        width: size ?? 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.all(0),
          ),
          onPressed: onPressed,
          child: Icon(
            altIcon ?? Icons.edit,
            color: color,
            size: size == null ? 20 : size! * 0.8,
          ),
        ),
      ),
    );
  }
}
