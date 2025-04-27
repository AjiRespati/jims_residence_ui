// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class InvoicePayment extends StatefulWidget with GetItStatefulWidgetMixin {
  InvoicePayment({required this.item, super.key});

  final dynamic item;
  @override
  State<InvoicePayment> createState() => _InvoicdPaymentState();
}

class _InvoicdPaymentState extends State<InvoicePayment> with GetItStateMixin {
  dynamic _invoice;
  List<dynamic> _charges = [];

  @override
  void initState() {
    RoomViewModel model = get<RoomViewModel>();
    super.initState();
    _invoice = widget.item;
    _charges = widget.item['Charges'];

    model.invoiceId = _invoice['id'];
    model.transactionDescription = "testing masih hardcode";
    model.transactionDate = DateTime.now(); // ini nanti diganti tanggal pilih
    model.transactionAmount =
        _invoice['totalAmountDue'].toDouble() -
        _invoice['totalAmountPaid']
            .toDouble(); // diganti input dengan default disamping
    // method is one of: 'Cash', 'Bank Transfer', 'Online Payment', 'Other'
    model.transactionMethod = "Cash"; // diganti dropdown pilihan
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Pembayaran",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(child: Text(_invoice['description'], maxLines: 2)),
                ],
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Text("Total pembayaran: "),
                Text(
                  formatCurrency(
                    _invoice['totalAmountDue'] - _invoice['totalAmountPaid'],
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 6),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _charges.length,
              itemBuilder: (context, index) {
                var charge = _charges[index];
                return Row(
                  children: [
                    SizedBox(width: 40),
                    Text(charge['name'] + ": "),
                    Text(formatCurrency(charge['amount'])),
                  ],
                );
              },
            ),
            SizedBox(height: 6),
            Text("Pastikan pembayaran telah diterima."),
            SizedBox(height: 26),
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GradientElevatedButton(
                    elevation: 3,
                    onPressed: () => Navigator.pop(context),
                    child: Text("Kembali"),
                  ),
                  GradientElevatedButton(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    elevation: 3,
                    onPressed: () async {
                      await get<RoomViewModel>().recordTransaction();
                      Navigator.pushNamed(context, tenantDetailRoute);
                    },
                    child: Text("Bayar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
