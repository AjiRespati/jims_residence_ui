import 'package:flutter/material.dart';
import 'package:residenza/features/kost/kost_desktop.dart';
import 'package:residenza/features/kost/kost_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Kost extends StatefulWidget with GetItStatefulWidgetMixin {
  Kost({super.key});

  @override
  State<Kost> createState() => _KostState();
}

class _KostState extends State<Kost> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    // get<RoomViewModel>().fetchKosts();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: KostDesktop(),
      mobileLayout: KostMobile(),
    );
  }
}
