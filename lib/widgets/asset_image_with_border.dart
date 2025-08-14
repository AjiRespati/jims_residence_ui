import 'package:flutter/material.dart';

class AssetImageWithBorder extends StatelessWidget {
  final String imagePath;
  final double radius;
  final double elevation;
  final Border? border;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AssetImageWithBorder({
    super.key,
    required this.imagePath,
    this.radius = 8.0,
    this.elevation = 4.0,
    this.border,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(width: width, height: height, imagePath, fit: fit),
      ),
    );
  }
}
