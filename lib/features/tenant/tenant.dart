import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/tenant_desktop.dart';
import 'package:frontend/features/tenant/tenant_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Tenant extends StatefulWidget with GetItStatefulWidgetMixin {
  Tenant({super.key});

  @override
  State<Tenant> createState() => _TenantState();
}

class _TenantState extends State<Tenant> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchTenants();
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
