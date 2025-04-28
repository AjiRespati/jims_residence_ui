import 'package:flutter/material.dart';
import 'package:residenza/features/tenant/tenant_desktop.dart';
import 'package:residenza/features/tenant/tenant_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TenantView extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantView({super.key});

  @override
  State<TenantView> createState() => _TenantViewState();
}

class _TenantViewState extends State<TenantView> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchTenants(
        boardingHouseId: get<RoomViewModel>().roomKostId,
        dateFrom: null,
        dateTo: null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: TenantDesktop(),
      mobileLayout: TenantMobile(),
    );
  }
}
