import 'package:flutter/material.dart';
import 'package:residenza/features/payments/components/invoice_payment.dart';
import 'package:residenza/utils/helpers.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 9,
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
                          Text("Batas pembayaran: "),
                          Text(formatHariDateString(item['dueDate'])),
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
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (item['totalAmountPaid'] < item['totalAmountDue'])
                        IconButton(
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(elevation: 8),
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
                          icon: Icon(
                            Icons.currency_exchange,
                            color: Colors.amber.shade700,
                          ),
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
                    formatHariDateString(
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
