// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class InvoiceVoid extends StatefulWidget with GetItStatefulWidgetMixin {
  InvoiceVoid({required this.item, super.key});

  final dynamic item;
  @override
  State<InvoiceVoid> createState() => _InvoicdPaymentState();
}

class _InvoicdPaymentState extends State<InvoiceVoid> with GetItStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? _paymentDate;
  dynamic _invoice;
  // List<dynamic> _charges = [];

  @override
  void initState() {
    RoomViewModel model = get<RoomViewModel>();
    super.initState();
    _invoice = widget.item;
    // _charges = widget.item['Charges'];

    model.invoiceId = _invoice['id'];
    model.transactionDescription = "testing masih hardcode";
    model.transactionDate = DateTime.now(); // ini nanti diganti tanggal pilih
    model.transactionAmount =
        _invoice['totalAmountDue'].toDouble() -
        _invoice['totalAmountPaid']
            .toDouble(); // diganti input dengan default disamping
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.item);
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
                  "BATALKAN TAGIHAN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(child: Text(_invoice['description'], maxLines: 2)),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(width: 8),
                Text("Jumlah tagihan: "),
                Text(
                  formatCurrency(_invoice['totalAmountDue']),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Akan dibatalkan !",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Apakah anda yakin?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            SizedBox(height: 15),
            SizedBox(height: 15),

            SizedBox(height: 26),
            SizedBox(
              height: 35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
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
                        colors: [Colors.red.shade400, Colors.red.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      elevation: 3,
                      onPressed: () async {
                        get<RoomViewModel>().transactionDate = _paymentDate;
                        // get<RoomViewModel>().transactionAmount = double.parse(
                        //   _rawValue,
                        // );
                        get<RoomViewModel>().tenantId =
                            widget.item['Tenant']['id'];
                        await get<RoomViewModel>().deleteInvoice(
                          id: widget.item['id'],
                        );
                        _amountController.text = "";
                        Navigator.pushNamed(context, tenantDetailRoute);
                      },
                      child: Text("Batalkan!"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 35),
          ],
        ),
      ),
    );
  }
}
