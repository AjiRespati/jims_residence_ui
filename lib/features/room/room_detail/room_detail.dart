import 'package:flutter/material.dart';
import 'package:frontend/features/room/room_detail/room_detail_desktop.dart';
import 'package:frontend/features/room/room_detail/room_detail_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';

class RoomDetail extends StatelessWidget {
  const RoomDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomDetailDesktop(),
      mobileLayout: RoomDetailMobile(),
    );
  }
}
