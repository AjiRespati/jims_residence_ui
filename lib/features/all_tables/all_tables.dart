import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/page_container.dart';

class AllTables extends StatefulWidget with GetItStatefulWidgetMixin {
  AllTables({super.key});

  @override
  State<AllTables> createState() => _AllTablesState();
}

class _AllTablesState extends State<AllTables> with GetItStateMixin {
  late RoomViewModel _model;

  void _setup() async {
    await _model.getAllTransactions();
    await _model.fetchInvoices(
      boardingHouseId: null,
      dateFrom: null,
      dateTo: null,
    );
    await _model.getAllCharges();
    await _model.fetchTenants(
      boardingHouseId: null,
      dateFrom: null,
      dateTo: null,
    );
  }

  @override
  void initState() {
    super.initState();
    _model = get<RoomViewModel>();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      // IconButton(
                      //   onPressed: () => Navigator.pop(context),
                      //   icon: Icon(Icons.arrow_back_ios_new, size: 25),
                      // ),
                      Text(
                        "ALL TABLES",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 40),

                      Row(children: [Text("Transactions Table: ")]),
                      SizedBox(
                        child:
                            watchOnly((RoomViewModel x) => x.isBusy)
                                ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                  ),
                                )
                                : watchOnly(
                                  (RoomViewModel x) => x.transactionsTable,
                                ).isEmpty
                                ? Text("Empty")
                                : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        get<RoomViewModel>()
                                            .transactionsTable
                                            .length,
                                    itemBuilder: (context, index) {
                                      var item =
                                          get<RoomViewModel>()
                                              .transactionsTable[index];
                                      // print(item);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        key: ValueKey(index + 19000),
                                        children: [
                                          Text(item['id']),
                                          IconButton(
                                            onPressed: () {
                                              _model.deleteTransaction(
                                                id: item['id'],
                                              );
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                      ),
                      SizedBox(height: 20),

                      Row(children: [Text("Invoices Table: ")]),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: get<RoomViewModel>().invoices.length,
                            itemBuilder: (context, index) {
                              var item = get<RoomViewModel>().invoices[index];
                              // print(item);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                key: ValueKey(index + 19000),
                                children: [
                                  Text(item['id']),
                                  IconButton(
                                    onPressed: () {
                                      _model.deleteInvoice(id: item['id']);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(children: [Text("Tenants Table: ")]),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: get<RoomViewModel>().tenants.length,
                            itemBuilder: (context, index) {
                              var item = get<RoomViewModel>().tenants[index];
                              // print(item);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                key: ValueKey(index + 19000),
                                children: [
                                  Text(item['id']),
                                  IconButton(
                                    onPressed: () {
                                      _model.deleteTenant(id: item['id']);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      Row(children: [Text("Charges Table: ")]),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: get<RoomViewModel>().charges.length,
                            itemBuilder: (context, index) {
                              var item = get<RoomViewModel>().charges[index];
                              // print(item);
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                key: ValueKey(index + 19000),
                                children: [
                                  Text(item['id']),
                                  IconButton(
                                    onPressed: () {
                                      _model.deleteCharge(id: item['id']);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}
