import 'package:flutter/material.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PaymentDetailMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentDetailMobile({super.key});

  @override
  State<PaymentDetailMobile> createState() => _PaymentDetailMobileState();
}

class _PaymentDetailMobileState extends State<PaymentDetailMobile>
    with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    final transaction = watchOnly((RoomViewModel x) => x.transaction);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    print(transaction);
    return Scaffold(
      appBar: AppBar(title: Text("Detail Transaksi")),
      bottomNavigationBar: MobileNavbar(selectedindex: 3),
    );
  }
}
