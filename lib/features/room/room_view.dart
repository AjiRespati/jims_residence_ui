import 'package:flutter/material.dart';
import 'package:residenza/features/room/room_desktop.dart';
import 'package:residenza/features/room/room_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/view_models/system_view_model.dart';

class RoomView extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomView({required this.isSetting, super.key});
  final bool isSetting;

  @override
  State<RoomView> createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchRooms(
        boardingHouseId: get<RoomViewModel>().roomKostId,
        dateFrom: null,
        dateTo: null,
      );
      get<RoomViewModel>().fetchKosts();
      get<SystemViewModel>().currentPageIndex = widget.isSetting ? 4 : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomDesktop(isSetting: widget.isSetting),
      mobileLayout: RoomMobile(isSetting: widget.isSetting),
    );
  }
}
