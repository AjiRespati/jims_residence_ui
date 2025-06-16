// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:residenza/features/tenant/components/add_tenant.dart';
import 'package:residenza/features/tenant/components/tenant_card.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/add_button.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';

class TenantMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantMobile({super.key});

  @override
  State<TenantMobile> createState() => _TenantMobileState();
}

class _TenantMobileState extends State<TenantMobile> with GetItStateMixin {
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
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Penghuni",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
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
                          get<RoomViewModel>().periode = dateFrom;
                          await get<RoomViewModel>().fetchTenants(
                            boardingHouseId: _boardingHouseId,
                            dateFrom: _dateFrom,
                            dateTo: _dateTo,
                          );
                        },
                        selectedMonth: watchOnly(
                          (RoomViewModel x) => x.periode,
                        ),
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
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
