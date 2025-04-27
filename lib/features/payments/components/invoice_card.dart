import 'package:flutter/material.dart';
import 'package:frontend/features/payments/components/invoice_payment.dart';
import 'package:frontend/utils/helpers.dart';

class InvoiceCard extends StatelessWidget {
  const InvoiceCard({super.key, required this.item});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Tanggal: "),
                    Text(formatDateString(item['issueDate'])),
                  ],
                ),
                Row(
                  children: [
                    Text("Total: "),
                    Text(formatCurrency(item['totalAmountDue'])),
                  ],
                ),
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
                Row(
                  children: [
                    Text("Batas pembayaran: "),
                    Text(formatDateString(item['dueDate'])),
                  ],
                ),
                Row(
                  children: [
                    Text("Jumlah terbayar: "),
                    Text(formatCurrency(item['totalAmountPaid'])),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                IconButton(
                  style: IconButton.styleFrom(elevation: 4),
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        minHeight: 490,
                        maxHeight: 750,
                      ),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: InvoicePayment(item: item),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.payment_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
