import 'package:flutter/material.dart';
import 'package:frontend/features/room/room_desktop.dart';
import 'package:frontend/features/room/room_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomView extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomView({super.key});

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchRooms(isAfterEvent: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomDesktop(),
      mobileLayout: RoomMobile(),
    );
  }
}
