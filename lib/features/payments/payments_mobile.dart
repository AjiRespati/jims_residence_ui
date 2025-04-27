import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PaymentsMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentsMobile({super.key});

  @override
  State<PaymentsMobile> createState() => _PaymentsMobileState();
}

class _PaymentsMobileState extends State<PaymentsMobile> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.invoices);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Transaksi")),
      body: ListView.builder(
        itemCount: get<RoomViewModel>().invoices.length,
        itemBuilder: (context, idx) {
          dynamic invoice = get<RoomViewModel>().invoices[idx];
          // dynamic invoice = invoice['Invoice'];
          dynamic tenant = invoice['Tenant'];
          dynamic room = invoice['Room'];
          dynamic transactions = invoice['Transactions'];
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: ClipRRect(
                child: InkWell(
                  onTap: () {
                    get<RoomViewModel>().choosenInvoiceId = invoice['id'];
                    Navigator.pushNamed(context, paymentDetailRoute);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tenant == null && room == null)
                                Flexible(
                                  child: Text(
                                    invoice['description'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
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

                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Text(
                                    invoiceStatusText(invoice['status']),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (transactions.length > 0)
                                    Text(
                                      ": ${formatDateString(transactions[0]['transactionDate'])}",
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                formatCurrency(
                                  invoice['totalAmountDue'].toDouble(),
                                ),
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
        },
      ),
      bottomNavigationBar: MobileNavbar(selectedindex: 3),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
