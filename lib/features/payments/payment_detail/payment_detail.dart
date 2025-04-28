import 'package:flutter/material.dart';
import 'package:residenza/features/payments/payment_detail/payment_detail_desktop.dart';
import 'package:residenza/features/payments/payment_detail/payment_detail_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PaymentDetail extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentDetail({super.key});

  @override
  State<PaymentDetail> createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<RoomViewModel>().fetchInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: PaymentDetailDesktop(),
      mobileLayout: PaymentDetailMobile(),
    );
  }
}
