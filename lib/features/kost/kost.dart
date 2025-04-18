import 'package:flutter/material.dart';
import 'package:frontend/features/kost/kost_desktop.dart';
import 'package:frontend/features/kost/kost_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
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
