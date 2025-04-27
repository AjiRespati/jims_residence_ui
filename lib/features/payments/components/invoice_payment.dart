import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class InvoicePayment extends StatefulWidget with GetItStatefulWidgetMixin {
  InvoicePayment({required this.item, super.key});

  final dynamic item;
  @override
  State<InvoicePayment> createState() => _InvoicdPaymentState();
}

class _InvoicdPaymentState extends State<InvoicePayment> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 6),
            Row(
              children: [
                Text(
                  "Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
