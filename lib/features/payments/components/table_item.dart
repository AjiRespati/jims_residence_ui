import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';

class TableItem extends StatelessWidget with GetItMixin {
  TableItem({required this.item, super.key});

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 1,
        child: ClipRRect(
          child: InkWell(
            onTap:
                item['transactionType'] == 'debit'
                    ? null
                    : () {
                      get<RoomViewModel>().choosenInvoiceId = item['id'];
                      Navigator.pushNamed(context, paymentDetailRoute);
                    },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['tenant'] == "N/A"
                              ? item['description']
                              : item['tenant'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            formatDateFromYearToDay(
                              DateTime.parse(item['transactionDate']),
                            ),
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 35, width: 1, color: Colors.grey),
                    ],
                  ),
                  Expanded(
                    flex: 6,
                    child:
                        item['transactionType'] == 'debit'
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(item['amount'].toDouble()),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  item['createBy'] == "N/A"
                                      ? ""
                                      : invoiceStatusText(item['createBy']),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                            : SizedBox(),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 35, width: 1, color: Colors.grey),
                    ],
                  ),

                  Expanded(
                    flex: 6,
                    child:
                        item['transactionType'] == 'credit'
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(
                                    item['totalAmountPaid'].toDouble(),
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  item['status'] == "N/A"
                                      ? ""
                                      : invoiceStatusText(item['status']),
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            )
                            : SizedBox(),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
