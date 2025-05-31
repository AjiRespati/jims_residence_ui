import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';

class InvoiceItem extends StatelessWidget with GetItMixin {
  InvoiceItem({
    required this.invoice,
    required this.tenant,
    required this.room,
    required this.transactions,
    super.key,
  });

  final dynamic invoice;
  final dynamic tenant;
  final dynamic room;
  final dynamic transactions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: ClipRRect(
          child: InkWell(
            onTap: () {
              get<RoomViewModel>().choosenInvoiceId = invoice['id'];
              Navigator.pushNamed(context, paymentDetailRoute);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tenant != null)
                          Text(
                            tenant['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        if (room != null)
                          Row(
                            children: [
                              Text(room['BoardingHouse']['name'] + ","),
                              SizedBox(width: 5),
                              Text(room['roomNumber']),
                            ],
                          ),
                        SizedBox(height: 5),
                        Text(
                          invoice['description'] ?? "-",
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatCurrency(invoice['totalAmountPaid'].toDouble()),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              invoiceStatusText(invoice['status']),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            SizedBox(width: 20),
                            if (transactions.length > 0)
                              Text(
                                formatDateString(
                                  transactions[0]['transactionDate'],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
