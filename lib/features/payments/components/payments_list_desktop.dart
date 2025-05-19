import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/payments/components/invoice_item.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';
import 'package:residenza/widgets/page_container.dart';

class PaymentsListDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentsListDesktop({super.key});

  @override
  State<PaymentsListDesktop> createState() => _PaymentsListDesktopState();
}

class _PaymentsListDesktopState extends State<PaymentsListDesktop>
    with GetItStateMixin, SingleTickerProviderStateMixin {
  String? _boardingHouseId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final now = DateTime.now();

      get<RoomViewModel>().getFinancialOverview(
        boardingHouseId: get<RoomViewModel>().roomKostId,
        dateFrom: DateTime(now.year, now.month),
        dateTo: DateTime(
          now.year,
          now.month + 1,
        ).subtract(Duration(seconds: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.invoices);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
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

                              get<RoomViewModel>().getFinancialOverview(
                                boardingHouseId: _boardingHouseId,
                                dateFrom: _dateFrom,
                                dateTo: _dateTo,
                              );

                              get<RoomViewModel>().getMonthlyReport(
                                boardingHouseId: _boardingHouseId,
                                month: _dateFrom?.month ?? DateTime.now().month,
                                year: _dateFrom?.year ?? DateTime.now().year,
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

                              get<RoomViewModel>().getFinancialOverview(
                                boardingHouseId: _boardingHouseId,
                                dateFrom: _dateFrom,
                                dateTo: _dateTo,
                              );

                              get<RoomViewModel>().getMonthlyReport(
                                boardingHouseId: _boardingHouseId,
                                month: _dateFrom?.month ?? DateTime.now().month,
                                year: _dateFrom?.year ?? DateTime.now().year,
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
              Divider(thickness: 0.5),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "Tagihan (${get<RoomViewModel>().invoices.length})",
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    formatCurrency(get<RoomViewModel>().totalInvoicesPaid),
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: get<RoomViewModel>().invoices.length,
                  itemBuilder: (context, idx) {
                    dynamic invoice = get<RoomViewModel>().invoices[idx];
                    dynamic tenant = invoice['Tenant'];
                    dynamic room = invoice['Room'];
                    dynamic transactions = invoice['Transactions'];
                    return InvoiceItem(
                      invoice: invoice,
                      tenant: tenant,
                      room: room,
                      transactions: transactions,
                    );
                  },
                ),
              ),
              Divider(thickness: 0.5),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text(
                    "Pengeluaran (${get<RoomViewModel>().expenses.length})",
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  Text(
                    formatCurrency(get<RoomViewModel>().totalExpensesAmount),
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              SizedBox(height: 4),
              Expanded(
                child: ListView.builder(
                  itemCount: get<RoomViewModel>().expenses.length,
                  itemBuilder: (context, idx) {
                    dynamic expense = get<RoomViewModel>().expenses[idx];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom:
                            idx == (get<RoomViewModel>().expenses.length - 1)
                                ? 40
                                : 4,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 1,
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
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            expense['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(expense['BoardingHouse']['name']),
                                    SizedBox(height: 4),
                                    Text(
                                      expense['createBy'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            expense['description'],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
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
                                      formatCurrency(
                                        expense['amount'].toDouble(),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      expense['paymentMethod'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 20),
                                        Text(
                                          formatDateString(
                                            expense['expenseDate'],
                                          ),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
