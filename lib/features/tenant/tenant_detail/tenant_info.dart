// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/edit_button.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';

class TenantInfo extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.nik,
    required this.status,
    required this.startDate,
    required this.endDate,
    super.key,
  });

  final String id;
  final String name;
  final String phone;
  final String nik;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  State<TenantInfo> createState() => _TenantInfoState();
}

class _TenantInfoState extends State<TenantInfo> with GetItStateMixin {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nik = TextEditingController();
  final TextEditingController _status = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name.text = widget.name;
    _phone.text = widget.phone;
    _nik.text = widget.nik;
    _status.text = widget.status;
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Nama: ", style: TextStyle(fontSize: 14)),
                Text(
                  _name.text,
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text("Telepon: ", style: TextStyle(fontSize: 14)),
                Text(
                  _phone.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text("NIK: ", style: TextStyle(fontSize: 14)),
                Text(
                  _nik.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            Row(
              children: [
                Text("Masuk: ", style: TextStyle(fontSize: 14)),
                Text(
                  _startDate != null
                      ? formatDateFromYearToDay(_startDate!)
                      : " -",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
            if (widget.status == "Inactive")
              Row(
                children: [
                  Text("Keluar: ", style: TextStyle(fontSize: 14)),
                  Text(
                    _endDate != null
                        ? formatDateFromYearToDay(_endDate!)
                        : " -",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
            Row(
              children: [
                Text("Status: ", style: TextStyle(fontSize: 14)),
                Text(
                  _status.text,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
        if (widget.status != "Inactive")
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: EditButton(
              message: "",
              size: 35,
              color: Colors.blue,
              onPressed: () async {
                await showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
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
                              'Edit Tenant Data',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade700,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                label: Text("Nama"),
                              ),
                              controller: _name,
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                label: Text("Telepon"),
                              ),
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 6),
                            TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                label: Text("NIK"),
                              ),
                              controller: _nik,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 6),
                            SizedBox(height: 6),

                            _buildDatePicker(
                              context,
                              "Pilih tanggal mulai",
                              "Mulai:  ",
                              _startDate,
                              (date) {
                                _startDate = date;
                                setState(() {
                                  _startDate = date;
                                });
                              },
                              dateTextStyle: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              labelTextStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),

                            SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(labelText: "Status"),
                              value: _status.text,
                              items:
                                  ['Active', 'Inactive', 'Waiting'].map((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                _status.text = value ?? "";
                                setState(() {});
                              },
                            ),
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
                                    onPressed: () async {
                                      await get<RoomViewModel>().updateTenant(
                                        tenantId: widget.id,
                                        name: _name.text,
                                        phone: _phone.text,
                                        nik: _nik.text,
                                        status: _status.text,
                                        startDate: _startDate,
                                        endDate: _endDate,
                                        imageWeb: null,
                                        imageDevice: null,
                                      );

                                      Navigator.pop(context);
                                    },
                                    child: Text("Edit"),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                );

                setState(() {});
              },
            ),
          ),
      ],
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
