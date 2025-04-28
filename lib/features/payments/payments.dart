import 'package:flutter/material.dart';
import 'package:residenza/features/payments/payments_desktop.dart';
import 'package:residenza/features/payments/payments_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class Payments extends StatefulWidget with GetItStatefulWidgetMixin {
  Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchInvoices(
        boardingHouseId: get<RoomViewModel>().roomKostId,
        dateFrom: null,
        dateTo: null,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: PaymentsMobile(),
      desktopLayout: PaymentsDesktop(),
    );
  }
}
