import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
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
    watchOnly((RoomViewModel x) => x.transactions);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Keuangan")),
      body: ListView.builder(
        itemCount: get<RoomViewModel>().transactions.length,
        itemBuilder: (context, idx) {
          dynamic transaction = get<RoomViewModel>().transactions[idx];
          dynamic invoice = transaction['Invoice'];
          dynamic tenant = transaction['Invoice']['Tenant'];
          dynamic room = transaction['Invoice']['Room'];
          // print(transaction);
          // print("==========================");
          // print(invoice);
          // print("==========================");
          // print(tenant);
          // print("==========================");
          // print(room);
          // print("==========================");
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: ClipRRect(
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, paymentDetailRoute),
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
                                    transaction['description'],
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
                              Text(
                                formatHariDateString(
                                  transaction['transactionDate'],
                                ),
                              ),
                              Text(_invoiceStatusText(invoice['status'])),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                formatCurrency(
                                  transaction['amount'].toDouble(),
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

  String _invoiceStatusText(String status) {
    // 'Draft', 'Issued', 'Unpaid', 'PartiallyPaid', 'Paid', 'Void'
    switch (status) {
      case 'Issued':
        return 'Unpaid';
      case 'PartiallyPaid':
        return 'Sebagian';
      default:
        return status;
    }
  }
}
