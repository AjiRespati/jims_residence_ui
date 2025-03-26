import 'package:flutter/material.dart';
import 'package:frontend/features/home/home_desktop.dart';
import 'package:frontend/features/home/home_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: HomeDesktop(),
      mobileLayout: HomeMobile(),
    );
  }
}
