// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddTenant extends StatefulWidget with GetItStatefulWidgetMixin {
  AddTenant({super.key});

  @override
  State<AddTenant> createState() => _AddTenantState();
}

class _AddTenantState extends State<AddTenant> with GetItStateMixin {
  DateTime? _selectedDate;
  String _selectedShowDate = 'Nanti';
  final List<String> _pilihDate = ['Sekarang', 'Nanti'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 6),
          Text(
            "Daftarkan Penghuni Baru",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(isDense: true, label: Text("Nama")),
            keyboardType: TextInputType.name,
            onChanged: (value) => get<RoomViewModel>().tenantName = value,
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(isDense: true, label: Text("Telepon")),
            keyboardType: TextInputType.number,
            onChanged: (value) => get<RoomViewModel>().tenantPhone = value,
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(isDense: true, label: Text("NIK")),
            keyboardType: TextInputType.number,
            onChanged: (value) => get<RoomViewModel>().tenantIdNumber = value,
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Menyerahkan Foto Copy KTP"),
            value: get<RoomViewModel>().isIdCopiedText,
            items:
                ["Ya", "Belum"].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              get<RoomViewModel>().isIdCopiedText = value ?? "Belum";
            },
          ),
          SizedBox(height: 16),
          Row(children: [Text("Pilih tanggal mulai:")]),
          Row(
            children:
                _pilihDate.map((language) {
                  return Expanded(
                    child: RadioListTile<String>(
                      dense: true,
                      title: Text(language),
                      value: language,
                      groupValue: _selectedShowDate,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedShowDate = value!;
                          if (value == 'Nanti') {
                            _selectedDate = null;
                            get<RoomViewModel>().tenantStartDate = null;
                          }
                        });
                      },
                    ),
                  );
                }).toList(),
          ),
          if (_selectedShowDate == 'Sekarang')
            Row(
              children: [
                _buildDatePicker(
                  context,
                  "Tanggal mulai: ",
                  _selectedDate,
                  (date) {
                    get<RoomViewModel>().tenantStartDate = date;
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  dateTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

          SizedBox(height: 30),
          GradientElevatedButton(
            onPressed: () async {
              get<RoomViewModel>().tenantStatus = "Active";
              await get<RoomViewModel>().addTenant(context: context);
              Navigator.pop(context);
            },
            child: Text(
              "Daftarkan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    Function(DateTime) onDateSelected, {
    TextStyle? dateTextStyle,
    TextStyle? labelTextStyle,
  }) {
    return SizedBox(
      height: 34,
      child: ElevatedButton(
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
            Text(label, style: labelTextStyle),
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
