// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class EditRoomStatus extends StatelessWidget with GetItMixin {
  EditRoomStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Ubah Status Kamar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          // TextFormField(
          //   decoration: InputDecoration(
          //     isDense: true,
          //     label: Text("Nomor Kamar"),
          //   ),
          //   keyboardType: TextInputType.number,
          //   onChanged: (value) => get<RoomViewModel>().roomNumber = value,
          // ),
          // SizedBox(height: 6),
          // DropdownButtonFormField<String>(
          //   decoration: InputDecoration(labelText: "Ukuran Kamar"),
          //   value: get<RoomViewModel>().roomSize,
          //   items:
          //       ["Kecil", "Standard", "Besar"].map((item) {
          //         return DropdownMenuItem<String>(
          //           value: item,
          //           child: Text(item),
          //         );
          //       }).toList(),
          //   onChanged: (value) {
          //     get<RoomViewModel>().roomSize = value ?? "Standard";
          //   },
          // ),
          // SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Status Kamar"),
            value: get<RoomViewModel>().roomStatus,
            items:
                ["Tersedia", "Terisi", "Pemeliharaan", "Rusak"].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              get<RoomViewModel>().roomStatus = value ?? "Tersedia";
            },
          ),
          // SizedBox(height: 6),
          // TextFormField(
          //   decoration: InputDecoration(
          //     isDense: true,
          //     label: Text("Harga Kamar"),
          //   ),
          //   keyboardType: TextInputType.number,
          //   onChanged:
          //       (value) =>
          //           get<RoomViewModel>().basicPrice = double.parse(value),
          // ),
          SizedBox(height: 70),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GradientElevatedButton(
                onPressed: () async {
                  get<RoomViewModel>().isBusy = true;
                  await get<RoomViewModel>().addRoom(context: context);
                  Navigator.pop(context);
                },
                child: Text(
                  "Tambah Kamar",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (watchOnly((RoomViewModel x) => x.isBusy))
                Row(
                  children: [
                    SizedBox(width: 20),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
