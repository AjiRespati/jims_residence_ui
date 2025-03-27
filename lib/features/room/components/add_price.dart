// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddPrice extends StatelessWidget with GetItMixin {
  AddPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 6),
          Text(
            "Tambahan Biaya Bulanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Nama Biaya"),
            ),
            keyboardType: TextInputType.name,
            onChanged: (value) => get<RoomViewModel>().addPriceName = value,
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(isDense: true, label: Text("Harga")),
            keyboardType: TextInputType.number,
            onChanged:
                (value) =>
                    get<RoomViewModel>().addPriceAmount = double.parse(value),
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Keterangan"),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) => get<RoomViewModel>().addPriceDesc = value,
          ),
          SizedBox(height: 6),
          SizedBox(height: 6),

          SizedBox(height: 30),
          GradientElevatedButton(
            onPressed: () async {
              await get<RoomViewModel>().createAdditionalPrice(
                context: context,
              );
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
