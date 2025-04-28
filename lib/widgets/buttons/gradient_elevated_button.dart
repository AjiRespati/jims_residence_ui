import 'package:flutter/material.dart';

class GradientElevatedButton extends StatefulWidget {
  const GradientElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Color.fromRGBO(30, 48, 241, 1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.elevation = 8.0,
    this.borderRadius = 10.0,
    this.buttonHeight = 40,
    this.inactiveDelay = Durations.extralong4,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient gradient;
  final double elevation;
  final double borderRadius;
  final double buttonHeight;
  final Duration inactiveDelay;

  @override
  State<GradientElevatedButton> createState() => _GradientElevatedButtonState();
}

class _GradientElevatedButtonState extends State<GradientElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.buttonHeight,
      decoration: BoxDecoration(
        // Define the gradient here
        gradient: widget.gradient,
        // Optional: Add border radius to match button shape
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          elevation: widget.elevation, // Shadow elevation
          backgroundColor:
              Colors.transparent, // Make button background transparent
          shadowColor: Colors.transparent, // Remove shadow if any
          foregroundColor: Colors.white, // Set text/icon color to be visible

          iconColor: Colors.white, // Icon color
        ),
        onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
