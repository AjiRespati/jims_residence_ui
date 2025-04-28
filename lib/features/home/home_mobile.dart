import 'package:flutter/material.dart';

import 'package:frontend/widgets/mobile_navbar.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Residenza",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
