import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/month_selector_dropdown.dart';

class TransferOwnerMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TransferOwnerMobile({super.key});

  @override
  State<TransferOwnerMobile> createState() => _TransferOwnerMobileState();
}

class _TransferOwnerMobileState extends State<TransferOwnerMobile>
    with GetItStateMixin {
  final now = DateTime.now();
  String? _boardingHouseId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RoomViewModel model = get<RoomViewModel>();
      DateTime? periode = model.periode;
      if (model.roomKostId != null) {
        var item =
            model.kosts
                .where((el) => el['id'] == model.roomKostId)
                .toList()
                .first;
        model.roomKostName = item['name'];
        _boardingHouseId = item['id'];
      } else {
        model.roomKostName = null;
        _boardingHouseId = null;
      }

      model.getAllTransferOwners(
        boardingHouseId: model.roomKostId,
        dateFrom:
            periode != null
                ? DateTime(periode.year, periode.month, 1)
                : DateTime(now.year, now.month, 1),
        dateTo:
            periode != null
                ? DateTime(
                  periode.year,
                  periode.month + 1,
                ).subtract(Duration(seconds: 1))
                : DateTime(
                  now.year,
                  now.month + 1,
                ).subtract(Duration(seconds: 1)),
      );
      model.periode =
          periode != null
              ? DateTime(periode.year, periode.month)
              : DateTime(now.year, now.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.transferOwners);
    watchOnly((RoomViewModel x) => x.roomKostId);

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
                    flex: 6,
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

                        get<RoomViewModel>().getAllTransferOwners(
                          boardingHouseId: _boardingHouseId,
                          dateFrom: _dateFrom,
                          dateTo: _dateTo?.subtract(Duration(seconds: 1)),
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

                        get<RoomViewModel>().getAllTransferOwners(
                          boardingHouseId: _boardingHouseId,
                          dateFrom: _dateFrom,
                          dateTo: _dateTo?.subtract(Duration(seconds: 1)),
                        );
                      },
                      selectedMonth: watchOnly((RoomViewModel x) => x.periode),
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
              "Transfer Ke Pemilik (${get<RoomViewModel>().transferOwners.length})",
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Spacer(),
            Text(
              formatCurrency(get<RoomViewModel>().totalTransferOwnerAmount),
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
            itemCount: get<RoomViewModel>().transferOwners.length,
            itemBuilder: (context, idx) {
              dynamic item = get<RoomViewModel>().transferOwners[idx];
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
                                      formatDateFromYearToDay(
                                        DateTime.parse(item['transferDate']),
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Text(item['BoardingHouse']['name']),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      item['description'],
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
                                formatCurrency(item?['amount'] ?? 0.toDouble()),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // SizedBox(height: 10),
                              // Text(
                              //   item['paymentMethod'],
                              //   style: TextStyle(fontWeight: FontWeight.bold),
                              // ),
                              // Row(
                              //   children: [
                              //     SizedBox(width: 20),
                              //     Text(
                              //       formatDateString(item['expenseDate']),
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
    );
  }
}
