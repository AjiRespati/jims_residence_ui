import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/payments/components/resume_item.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DateTime? periode = get<RoomViewModel>().periode;
      get<RoomViewModel>().getMonthlyReport(
        boardingHouseId: get<RoomViewModel>().roomKostId,
        month: periode != null ? periode.month : DateTime.now().month,
        year: periode != null ? periode.year : DateTime.now().year,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.kostMonthlyReport);
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
                        get<RoomViewModel>().periode = dateFrom;

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
        Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: get<RoomViewModel>().kostMonthlyReport.length,
            itemBuilder: (context, index) {
              final item = get<RoomViewModel>().kostMonthlyReport[index];
              return ResumeItem(item: item);
            },
          ),
        ),
      ],
    );
  }
}
