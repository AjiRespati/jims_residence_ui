// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddRoom extends StatelessWidget with GetItMixin {
  AddRoom({super.key});

  @override
  Widget build(BuildContext context) {
    print(get<RoomViewModel>().prices);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Tambah Kamar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Pilih Kost"),
            value: get<RoomViewModel>().roomKostName,
            items:
                get<RoomViewModel>().kosts.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['name'],
                    child: Text(item['name']),
                  );
                }).toList(),
            onChanged: (value) {
              get<RoomViewModel>().roomKostName = value;
              var item =
                  get<RoomViewModel>().kosts
                      .where((el) => el['name'] == value)
                      .toList()
                      .first;
              get<RoomViewModel>().roomKostId = item['id'];
            },
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Nomor Kamar"),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => get<RoomViewModel>().roomNumber = value,
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: "Ukuran Kamar"),
            value: get<RoomViewModel>().roomSize,
            items:
                ['Small', 'Standard', 'Big'].map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: (value) {
              get<RoomViewModel>().roomSize = value ?? "Standard";
            },
          ),
          SizedBox(height: 6),
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
          SizedBox(height: 6),
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
          DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(labelText: "Harga Kamar"),
            value: get<RoomViewModel>().selectedRoomPrice,
            items:
                get<RoomViewModel>().prices.map((item) {
                  return DropdownMenuItem<dynamic>(
                    value: item,
                    child: Text(item['name']),
                  );
                }).toList(),
            onChanged: (value) {
              get<RoomViewModel>().selectedRoomPrice = value;
            },
          ),
          SizedBox(height: 30),
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              GradientElevatedButton(
                onPressed: () async {
                  get<RoomViewModel>().isBusy = true;
                  await get<RoomViewModel>().addRoom();
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
