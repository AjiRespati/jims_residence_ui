import 'package:flutter/material.dart';

import 'package:residenza/features/home/home_mobile.dart';
import 'package:residenza/features/landing/landing_desktop.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/view_models/room_view_model.dart';

class Landing extends StatefulWidget with GetItStatefulWidgetMixin {
  Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // get<SystemViewModel>().self(context: context);
      get<RoomViewModel>().fetchKosts();
      // get<RoomViewModel>().fetchPrices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: LandingDesktop(),
      mobileLayout: HomeMobile(),
    );
  }
}
