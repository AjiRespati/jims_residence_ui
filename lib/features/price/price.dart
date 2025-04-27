import 'package:flutter/material.dart';
import 'package:residenza/features/price/price_desktop.dart';
import 'package:residenza/features/price/price_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';

class Price extends StatefulWidget {
  const Price({super.key});

  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: PriceMobile(),
      desktopLayout: PriceDesktop(),
    );
  }
}
