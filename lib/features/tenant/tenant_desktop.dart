import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/tenant/components/tenant_card.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';
import 'package:residenza/widgets/page_container.dart';

class TenantDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantDesktop({super.key});

  @override
  State<TenantDesktop> createState() => _TenantDesktopState();
}

class _TenantDesktopState extends State<TenantDesktop> with GetItStateMixin {
  String? _boardingHouseId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  Widget build(BuildContext context) {
    final tenants = watchOnly((RoomViewModel x) => x.tenants);
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
                              await get<RoomViewModel>().fetchTenants(
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
                              await get<RoomViewModel>().fetchTenants(
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
              get<RoomViewModel>().tenants.isEmpty
                  ? Center(child: Text("No tenants found"))
                  : Expanded(
                    child: ListView.builder(
                      itemCount: tenants.length,
                      itemBuilder: (context, idx) {
                        final item = tenants[idx];
                        return TenantCard(item: item);
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
