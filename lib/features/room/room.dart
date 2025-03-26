import 'package:flutter/material.dart';
import 'package:frontend/features/room/room_desktop.dart';
import 'package:frontend/features/room/room_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Room extends StatefulWidget with GetItStatefulWidgetMixin {
  Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchRooms();
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
