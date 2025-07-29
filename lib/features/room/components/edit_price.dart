// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:intl/intl.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/currency_text_field.dart';

class EditPrice extends StatefulWidget with GetItStatefulWidgetMixin {
  EditPrice({super.key});

  @override
  State<EditPrice> createState() => _EditPriceState();
}

class _EditPriceState extends State<EditPrice> with GetItStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );
  // dynamic _room;
  // dynamic _kost;
  // dynamic _tenant;
  // dynamic _payments;
  dynamic _price;
  // final double _totalAdditionalPrice = 0;
  double? _priceAmount;
  DateTime? _startDate;
  DateTime? _startDateEdit;

  @override
  void initState() {
    super.initState();

    _price = get<RoomViewModel>().price;
    // _startDate = DateTime.parse(_price['createdAt']);

    String checkinDate = _price['Rooms'][0]['Tenants'][0]['checkinDate'];
    _startDate = DateTime.parse(checkinDate);

    final rawText = (_price['amount'] ?? "").toString();

    final number = int.parse(rawText.isEmpty ? "0" : rawText);
    _amountController.text = _currencyFormatter.format(number);
    // _room = get<RoomViewModel>().room;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Edit Harga Kamar',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.blue.shade700,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),

            // TextFormField(
            //   decoration: InputDecoration(
            //     isDense: true,
            //     label: Text("Nama"),
            //   ),
            //   // controller: _name,
            // ),
            // SizedBox(height: 6),
            // TextFormField(
            //   decoration: InputDecoration(
            //     isDense: true,
            //     label: Text("Telepon"),
            //   ),
            //   // controller: _phone,
            //   keyboardType: TextInputType.phone,
            // ),
            // SizedBox(height: 6),
            // TextFormField(
            //   decoration: InputDecoration(
            //     isDense: true,
            //     label: Text("NIK"),
            //   ),
            //   // controller: _nik,
            //   keyboardType:
            //       TextInputType.number,
            // ),
            // SizedBox(height: 6),
            // SizedBox(height: 6),
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                label: Text("Tanggal mulai berlaku"),
              ),
              initialValue: formatDateFromYearToDay(_startDate),
              enabled: false,
            ),
            SizedBox(height: 6),
            SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: CurrencyTextField(
                controller: _amountController,
                label: "Edit harga kamar",
                onChanged: (value) => _priceAmount = double.parse(value),
              ),
            ),
            SizedBox(height: 6),
            SizedBox(height: 6),
            _buildDatePicker(
              context,
              "Ubah tanggal mulai berlaku",
              "Mulai berlaku:  ",
              _startDateEdit,
              (date) {
                // _startDate = date;
                setState(() {
                  _startDateEdit = date;
                });
              },
              dateTextStyle: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
              labelTextStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 6),
            SizedBox(height: 6),

            // DropdownButtonFormField<String>(
            //   decoration: InputDecoration(
            //     labelText: "Status",
            //   ),
            //   // value: _status.text,
            //   items:
            //       [
            //         'Active',
            //         'Inactive',
            //         'Waiting',
            //       ].map((item) {
            //         return DropdownMenuItem<
            //           String
            //         >(
            //           value: item,
            //           child: Text(item),
            //         );
            //       }).toList(),
            //   onChanged: (value) {
            //     // _status.text = value ?? "";
            //     // setState(() {});
            //   },
            // ),
            SizedBox(height: 26),
            SizedBox(
              // height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GradientElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Batal"),
                  ),
                  SizedBox(width: 20),
                  GradientElevatedButton(
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.shade400,
                        Colors.greenAccent.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onPressed: () async {
                      await get<RoomViewModel>().updatePrice(
                        id: _price['id'],
                        amount: _priceAmount ?? 0,
                        startDate: _startDateEdit,
                      );
                      await get<RoomViewModel>().fetchRoom();
                      await get<RoomViewModel>().fetchRooms(
                        boardingHouseId: get<RoomViewModel>().roomKostId,
                        dateFrom: null,
                        dateTo: null,
                      );

                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 5),
                        Text("Edit"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

Widget _buildDatePicker(
  BuildContext context,
  String placeholder,
  String label,
  DateTime? selectedDate,
  Function(DateTime) onDateSelected, {
  TextStyle? dateTextStyle,
  TextStyle? labelTextStyle,
}) {
  return SizedBox(
    height: 34,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      ),
      onPressed: () async {
        DateTime? pickedDate = await showCustomDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
        );
        // );
        if (pickedDate != null) onDateSelected(pickedDate);
      },
      child: Row(
        children: [
          Text(
            selectedDate == null ? placeholder : label,
            style: labelTextStyle,
          ),
          Text(
            selectedDate == null ? "" : formatDateFromYearToDay(selectedDate),
            // (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
            style: dateTextStyle,
          ),
        ],
      ),
    ),
  );
}
