import 'package:flutter/material.dart';
import 'package:residenza/features/room/room_add_tenant/room_add_tenant_desktop.dart';
import 'package:residenza/features/room/room_add_tenant/room_add_tenant_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';

class RoomAddTenant extends StatefulWidget {
  const RoomAddTenant({super.key});

  @override
  State<RoomAddTenant> createState() => _RoomAddTenantState();
}

class _RoomAddTenantState extends State<RoomAddTenant> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: RoomAddTenantDesktop(),
      mobileLayout: RoomAddTenantMobile(),
    );
  }
}
