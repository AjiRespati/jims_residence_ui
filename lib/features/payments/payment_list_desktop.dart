import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/payments/components/create_expense_content.dart';
import 'package:residenza/features/payments/components/table_item.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';
import 'package:residenza/widgets/page_container.dart';

class PaymentListDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentListDesktop({super.key});

  @override
  State<PaymentListDesktop> createState() => _PaymentListDesktopState();
}

class _PaymentListDesktopState extends State<PaymentListDesktop>
    with GetItStateMixin, SingleTickerProviderStateMixin {
  final now = DateTime.now();
  String? _boardingHouseId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final now = DateTime.now();

      get<RoomViewModel>().getFinancialTransactions(
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
    watchOnly((RoomViewModel x) => x.transactionsTable);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Column(
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

                                  // get<RoomViewModel>().getFinancialOverview(
                                  //   boardingHouseId: _boardingHouseId,
                                  //   dateFrom: _dateFrom,
                                  //   dateTo: _dateTo,
                                  // );

                                  // get<RoomViewModel>().getMonthlyReport(
                                  //   boardingHouseId: _boardingHouseId,
                                  //   month: _dateFrom?.month ?? DateTime.now().month,
                                  //   year: _dateFrom?.year ?? DateTime.now().year,
                                  // );

                                  get<RoomViewModel>().getFinancialTransactions(
                                    boardingHouseId: _boardingHouseId,
                                    dateFrom:
                                        _dateFrom ??
                                        DateTime(now.year, now.month),
                                    dateTo:
                                        _dateTo ??
                                        DateTime(
                                          now.year,
                                          now.month + 1,
                                        ).subtract(Duration(seconds: 1)),
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

                                  // get<RoomViewModel>().getFinancialOverview(
                                  //   boardingHouseId: _boardingHouseId,
                                  //   dateFrom: _dateFrom,
                                  //   dateTo: _dateTo,
                                  // );

                                  // get<RoomViewModel>().getMonthlyReport(
                                  //   boardingHouseId: _boardingHouseId,
                                  //   month: _dateFrom?.month ?? DateTime.now().month,
                                  //   year: _dateFrom?.year ?? DateTime.now().year,
                                  // );

                                  get<RoomViewModel>().getFinancialTransactions(
                                    boardingHouseId: _boardingHouseId,
                                    dateFrom:
                                        _dateFrom ??
                                        DateTime(now.year, now.month),
                                    dateTo:
                                        _dateTo ??
                                        DateTime(
                                          now.year,
                                          now.month + 1,
                                        ).subtract(Duration(seconds: 1)),
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
                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Expanded(
                          flex: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Keterangan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Debit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Kredit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: get<RoomViewModel>().transactionsTable.length,
                      itemBuilder: (context, idx) {
                        dynamic item =
                            get<RoomViewModel>().transactionsTable[idx];
                        return TableItem(item: item);
                      },
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Expanded(
                          flex: 15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Jumlah: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency(
                                  get<RoomViewModel>().totalInvoicesPaid,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatCurrency(
                                  get<RoomViewModel>().totalExpensesAmount,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.red.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100, right: 30),
                child: GradientElevatedButton(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(200, 211, 47, 47),
                      Color.fromARGB(200, 211, 47, 47),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),

                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: CreateExpenseContent(),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Pengeluaran",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
