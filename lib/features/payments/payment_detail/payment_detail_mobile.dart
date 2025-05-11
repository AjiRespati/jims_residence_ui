import 'package:flutter/material.dart';
import 'package:residenza/features/payments/components/invoice_payment.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
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
    final invoice = watchOnly((RoomViewModel x) => x.invoice);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      appBar: AppBar(title: Text("Detail Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            if (invoice != null)
              Expanded(
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (invoice['Tenant'] != null)
                          Row(
                            children: [
                              Text(
                                invoice['Tenant']['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        if (invoice['Room'] != null)
                          Row(
                            children: [
                              Text(invoice['Room']['BoardingHouse']['name']),
                            ],
                          ),
                        if (invoice['Room'] != null)
                          Row(
                            children: [
                              Text("Kamar "),
                              Text(invoice['Room']['roomNumber']),
                            ],
                          ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              "Invoice: ",
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              formatDateString(invoice['issueDate']),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Total: "),
                            Text(
                              formatCurrency(invoice['totalAmountDue']),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.deepOrange.shade900,
                              ),
                            ),
                          ],
                        ),
                        if (invoice['Charges'] != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: invoice['Charges'].length,
                            itemBuilder: (context, index) {
                              var charge = invoice['Charges'][index];
                              return Row(
                                children: [
                                  SizedBox(width: 20),
                                  Expanded(
                                    flex: 7,
                                    child: Text(
                                      charge['name'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 15,
                                    child: Text(
                                      ": ${formatCurrency(charge['amount'])}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(height: 10),

                        if (invoice['Transactions'] != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: invoice['Transactions'].length,
                            itemBuilder: (context, index) {
                              var item = invoice['Transactions'][index];
                              return Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Pembayaran: "),
                                      Text(
                                        formatDateMinuteString(
                                          item['transactionDate'],
                                        ),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.green.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Text("Jumlah: "),
                                      Text(
                                        formatCurrency(item['amount']),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.greenAccent.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        SizedBox(height: 10),

                        if ((invoice['totalAmountPaid'] > 0) &&
                            (invoice['totalAmountPaid'] <
                                invoice['totalAmountDue']))
                          Row(
                            children: [
                              Text("Jumlah terbayar: "),
                              Text(
                                formatCurrency(invoice['totalAmountPaid']),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.amberAccent.shade700,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              invoiceStatusText(invoice['status']),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: _generateColor(invoice['status']),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (invoice['status'] != 'Paid')
              Padding(
                padding: const EdgeInsets.all(20),
                child: GradientElevatedButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      constraints: BoxConstraints(),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: InvoicePayment(item: invoice),
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Pembayaran"),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: MobileNavbar(selectedindex: 3),
    );
  }
}

Color _generateColor(String status) {
  switch (status) {
    case "PartiallyPaid":
      return Colors.amber.shade800;
    case "Paid":
      return Colors.green.shade700;
    default:
      return Colors.red.shade600;
  }
}
