import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';

class PaymentListMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentListMobile({super.key});

  @override
  State<PaymentListMobile> createState() => _PaymentListMobileState();
}

class _PaymentListMobileState extends State<PaymentListMobile>
    with GetItStateMixin {
  String? _boardingHouseId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 20),
                  Flexible(
                    flex: 7,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Pilih Kost",
                        isDense: true,
                      ),
                      value: get<RoomViewModel>().roomKostName,
                      items:
                          get<RoomViewModel>().kosts.map((item) {
                            final isSelected =
                                item['name'] ==
                                get<RoomViewModel>().roomKostName;

                            return DropdownMenuItem<String>(
                              value: item['name'],
                              child: Text(
                                item['name'],
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                      onChanged: (value) async {
                        get<RoomViewModel>().roomKostName = value;
                        var item =
                            get<RoomViewModel>().kosts
                                .where((el) => el['name'] == value)
                                .toList()
                                .first;
                        get<RoomViewModel>().roomKostId = item['id'];
                        _boardingHouseId = item['id'];
                        await get<RoomViewModel>().fetchInvoices(
                          boardingHouseId: item['id'],
                          dateFrom: _dateFrom,
                          dateTo: _dateTo,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: MonthSelectorDropdown(
                      onMonthSelected: (
                        DateTime dateFrom,
                        DateTime dateTo,
                      ) async {
                        _dateFrom = dateFrom;
                        _dateTo = dateTo;
                        await get<RoomViewModel>().fetchInvoices(
                          boardingHouseId: _boardingHouseId,
                          dateFrom: _dateFrom,
                          dateTo: _dateTo,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        Divider(),
        Expanded(
          child: ListView.builder(
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
                              flex: 15,
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
                                        Text(
                                          room['BoardingHouse']['name'] + ",",
                                        ),
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
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
        ),
      ],
    );
  }
}
