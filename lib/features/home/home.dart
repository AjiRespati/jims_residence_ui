import 'package:flutter/material.dart';
import 'package:residenza/features/home/home_desktop.dart';
import 'package:residenza/features/home/home_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/view_models/system_view_model.dart';

class Home extends StatefulWidget with GetItStatefulWidgetMixin {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    get<SystemViewModel>().self(context: context);
    get<RoomViewModel>().fetchKosts();
    get<RoomViewModel>().fetchPrices();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: HomeDesktop(),
      mobileLayout: HomeMobile(),
    );
  }
}
