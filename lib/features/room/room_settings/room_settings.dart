import 'package:flutter/material.dart';
import 'package:frontend/features/room/room_settings/room_settings_desktop.dart';
import 'package:frontend/features/room/room_settings/room_settings_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomSettings extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomSettings({required this.datas, super.key});
  final dynamic datas;

  @override
  State<RoomSettings> createState() => _RoomSettingsState();
}

class _RoomSettingsState extends State<RoomSettings> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    print(widget.datas);
    get<RoomViewModel>().roomId = widget.datas['id'] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomSettingsDesktop(),
      mobileLayout: RoomSettingsMobile(datas: widget.datas),
    );
  }
}
