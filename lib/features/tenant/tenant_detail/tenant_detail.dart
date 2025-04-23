import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/tenant_detail/tenant_detail_desktop.dart';
import 'package:frontend/features/tenant/tenant_detail/tenant_detail_mobile.dart';
import 'package:frontend/utils/responsive_layout.dart';

class TenantDetail extends StatelessWidget {
  const TenantDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: TenantDetailDesktop(),
      mobileLayout: TenantDetailMobile(),
    );
  }
}
