import 'package:flutter/material.dart';
import 'package:frontend/features/room/room_detail/room_detail_desktop.dart';
import 'package:frontend/features/room/room_detail/room_detail_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomDetail extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomDetail({required this.datas, super.key});
  final dynamic datas;

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    get<RoomViewModel>().roomId = widget.datas['id'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomDetailDesktop(),
      mobileLayout: RoomDetailMobile(datas: widget.datas),
    );
  }
}
