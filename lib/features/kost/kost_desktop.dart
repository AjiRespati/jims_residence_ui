import 'package:flutter/material.dart';
import 'package:residenza/widgets/page_container.dart';

class KostDesktop extends StatelessWidget {
  const KostDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: Container(color: Colors.blueAccent),
      ),
    );
  }
}
