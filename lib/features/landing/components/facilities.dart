import 'package:flutter/material.dart';
import 'package:residenza/widgets/asset_image_with_border.dart';

class Facilities extends StatefulWidget {
  const Facilities({super.key});

  @override
  State<Facilities> createState() => _FacilitiesState();
}

class _FacilitiesState extends State<Facilities> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fasilitas',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            AssetImageWithBorder(imagePath: "images/wifi.png"),
            AssetImageWithBorder(imagePath: "images/AC.png"),
            AssetImageWithBorder(imagePath: "images/lemari.png"),
            AssetImageWithBorder(imagePath: "images/wc.png"),
          ],
        ),
      ],
    );
  }
}
