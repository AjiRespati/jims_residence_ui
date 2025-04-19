// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddTenant extends StatelessWidget with GetItMixin {
  AddTenant({super.key});

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
          SizedBox(height: 6),

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
}
