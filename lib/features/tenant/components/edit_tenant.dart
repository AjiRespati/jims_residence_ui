// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';

class EditTenant extends StatefulWidget with GetItStatefulWidgetMixin {
  EditTenant({required this.tenant, super.key});

  final dynamic tenant;

  @override
  State<EditTenant> createState() => _EditTenantState();
}

class _EditTenantState extends State<EditTenant> with GetItStateMixin {
  DateTime? _selectedDate;
  dynamic _tenant;
  String id = "";
  TextEditingController name = TextEditingController();
  TextEditingController nik = TextEditingController();
  TextEditingController phone = TextEditingController();
  // final DateTime _selectedDateNow = DateTime.now();
  // final String _selectedShowDate = 'Sekarang';
  // final List<String> _pilihDate = ['Sekarang', 'Nanti'];

  @override
  void initState() {
    super.initState();

    _tenant = widget.tenant;
    id = _tenant['id'];
    name.text = _tenant['name'];
    nik.text = _tenant['NIKNumber'];
    phone.text = _tenant['phone'];
    _selectedDate = DateTime.parse(_tenant['checkinDate']);
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    nik.dispose();
    phone.dispose();
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
              "Edit Penghuni",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 6),
            SizedBox(height: 6),
            TextFormField(
              controller: name,
              decoration: InputDecoration(isDense: true, label: Text("Nama")),
              keyboardType: TextInputType.name,
              onChanged: (value) => get<RoomViewModel>().tenantName = value,
            ),
            SizedBox(height: 6),
            TextFormField(
              controller: phone,
              decoration: InputDecoration(
                isDense: true,
                label: Text("Telepon"),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => get<RoomViewModel>().tenantPhone = value,
            ),
            SizedBox(height: 6),
            TextFormField(
              controller: nik,
              decoration: InputDecoration(isDense: true, label: Text("NIK")),
              keyboardType: TextInputType.number,
              onChanged: (value) => get<RoomViewModel>().tenantIdNumber = value,
            ),
            SizedBox(height: 6),
            SizedBox(height: 16),
            // Row(children: [Text("Pilih tanggal mulai:")]),
            _buildDatePicker(
              context,
              "Pilih tanggal mulai",
              "Tanggal mulai:  ",
              _selectedDate,
              (date) {
                get<RoomViewModel>().tenantStartDate = date;
                setState(() {
                  _selectedDate = date;
                });
              },
              dateTextStyle: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
              labelTextStyle: TextStyle(fontWeight: FontWeight.w600),
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
                    gradient: LinearGradient(
                      colors: [
                        Colors.greenAccent.shade400,
                        Colors.greenAccent.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    onPressed: () async {
                      await get<RoomViewModel>().updateTenant(
                        tenantId: id,
                        name: name.text,
                        phone: phone.text,
                        nik: nik.text,
                        status: null,
                        checkinDate: _selectedDate,
                        startDate: _selectedDate,
                        endDate: null,
                        imageWeb: null,
                        imageDevice: null,
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
              (selectedDate?.toLocal() ?? "").toString().split(' ')[0],
              style: dateTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
