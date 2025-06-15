import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/payments/components/invoice_payment.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/system_view_model.dart';

class InvoiceCard extends StatelessWidget with GetItMixin {
  InvoiceCard({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    int level = get<SystemViewModel>().level;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: item?['Charges'].length,
                        itemBuilder: (context, index) {
                          final item0 = item['Charges'][index];
                          return Row(
                            children: [
                              SizedBox(width: 20),
                              Text(item0['name'] + ": "),
                              Text(formatCurrency(item0['amount'])),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text("Jatuh Tempo: "),
                          Text(
                            formatHariTglBulThnDateString(item['dueDate']),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Jumlah terbayar: "),
                          Text(
                            formatCurrency(item['totalAmountPaid']),
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.blue.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Text(
                        invoiceStatusText(item["status"]),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: _generateColor(item['status']),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if ((item['totalAmountPaid'] < item['totalAmountDue']) &&
                          level > 0)
                        ElevatedButton(
                          onPressed: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: SingleChildScrollView(
                                    child: InvoicePayment(item: item),
                                  ),
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(5), // Adjust size
                            elevation: 4, // Optional: change elevation
                            backgroundColor:
                                Colors.amber.shade400, // Button color
                            foregroundColor: Colors.white, // Icon color
                          ),
                          child: Icon(
                            Icons.currency_exchange,
                          ), // Your desired icon
                        ),
                      if (item['totalAmountPaid'] >= item['totalAmountDue'])
                        Icon(Icons.check, color: Colors.green, size: 40),
                    ],
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Total:  "),
                Text(
                  formatCurrency(item['totalAmountDue']),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.blue.shade600,
                  ),
                ),
                Spacer(),
                if (item['Transactions'].isNotEmpty)
                  Text(
                    formatHariTglBulThnDateString(
                      item['Transactions'].last['transactionDate'],
                    ),
                    // formatHariDateString(item['issueDate']),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 'Draft', 'Issued', 'Unpaid', 'PartiallyPaid', 'Paid', 'Void'
Color _generateColor(String status) {
  switch (status) {
    case "Issued":
      return Colors.amber.shade800;
    case "PartiallyPaid":
      return Colors.amber.shade800;
    case "Paid":
      return Colors.green.shade700;
    default:
      return Colors.red.shade600;
  }
}
