import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';

class PaymentResumeMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentResumeMobile({super.key});

  @override
  State<PaymentResumeMobile> createState() => _PaymentResumeMobileState();
}

class _PaymentResumeMobileState extends State<PaymentResumeMobile>
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 2,
                  child: ClipRRect(
                    child: InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pemasukan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("Rp"),
                                      SizedBox(width: 5),
                                      Text("10.000.000,00"),
                                    ],
                                  ),

                                  SizedBox(height: 10),

                                  Row(
                                    children: [
                                      Text(
                                        "Belum ditransfer",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      Text("Rp5.000.000,00"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [Text(formatCurrency(10000000.0))],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
