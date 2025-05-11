// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/widgets/currency_text_field.dart';

class InvoicePayment extends StatefulWidget with GetItStatefulWidgetMixin {
  InvoicePayment({required this.item, super.key});

  final dynamic item;
  @override
  State<InvoicePayment> createState() => _InvoicdPaymentState();
}

class _InvoicdPaymentState extends State<InvoicePayment> with GetItStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String _rawValue = '';
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  dynamic _invoice;
  List<dynamic> _charges = [];

  void _onAmountChanged(String value) {
    String numericString = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.isEmpty) {
      _rawValue = '';
      _amountController.clear();
      return;
    }

    final number = int.parse(numericString);
    final formatted = _currencyFormatter.format(number);

    _rawValue = numericString;

    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

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
    model.transactionMethod = "Cash"; //TODO: diganti dropdown pilihan
  }

  @override
  void dispose() {
    super.dispose();
    _amountController.dispose();
    amountController.dispose();
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
                Text("Total belum dibayar: "),
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
            Row(
              children: [
                SizedBox(width: 40),
                Expanded(
                  child: CurrencyTextField(
                    controller: amountController,
                    label: "Jumlah Pembayaran",
                    onChanged: (value) {
                      _onAmountChanged(value);
                    },
                  ),
                ),
                SizedBox(width: 40),
              ],
            ),

            SizedBox(height: 6),
            Text("Pastikan pembayaran telah diterima."),
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
                        colors: [Colors.green.shade400, Colors.green.shade800],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      elevation: 3,
                      onPressed: () async {
                        get<RoomViewModel>().transactionAmount = double.parse(
                          _rawValue,
                        );
                        get<RoomViewModel>().tenantId =
                            widget.item['Tenant']['id'];
                        await get<RoomViewModel>().recordTransaction();
                        _amountController.text = "";
                        _rawValue = "";
                        Navigator.pushNamed(context, tenantDetailRoute);
                      },
                      child: Text("Bayar"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
