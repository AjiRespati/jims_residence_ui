// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/settings/settings_desktop.dart';
import 'package:residenza/features/settings/settings_mobile.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Settings extends StatefulWidget with GetItStatefulWidgetMixin {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with GetItStateMixin {
  Future<void> _setup() async {
    get<RoomViewModel>().isBusy = true;
    // await get<SystemViewModel>().self(context);
    // if ((get<SystemViewModel>().level ?? 0) > 3) {
    //   get<SystemViewModel>().getAllUser(context);
    //   get<RoomViewModel>().getAllFrezer(context);
    //   get<RoomViewModel>().getAllShops(context: context);
    //   get<RoomViewModel>().fetchPercentages();
    // }
    get<RoomViewModel>().fetchKosts();
    // get<RoomViewModel>().fetchPrices();

    get<RoomViewModel>().isBusy = false;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (get<SystemViewModel>().user == null) {
        Navigator.pushNamed(context, signInRoute);
      }
      get<SystemViewModel>().currentPageIndex =
          get<SystemViewModel>().user['level'] < 1 ? 2 : 4;
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: SettingsMobile(),
      desktopLayout: SettingsDesktop(),
    );
  }
}
