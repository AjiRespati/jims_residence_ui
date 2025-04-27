// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AddPrice extends StatefulWidget with GetItStatefulWidgetMixin {
  AddPrice({super.key});

  @override
  State<AddPrice> createState() => _AddPriceState();
}

class _AddPriceState extends State<AddPrice> with GetItStateMixin {
  String _priceName = "";
  String _priceDesc = "";
  double _priceAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 6),
          Text(
            "Biaya Tambahan Bulanan",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Nama Biaya"),
            ),
            keyboardType: TextInputType.name,
            onChanged: (value) => _priceName = value,
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(isDense: true, label: Text("Harga")),
            keyboardType: TextInputType.number,
            onChanged: (value) => _priceAmount = double.parse(value),
          ),
          SizedBox(height: 6),
          TextFormField(
            decoration: InputDecoration(
              isDense: true,
              label: Text("Keterangan"),
            ),
            onChanged: (value) => _priceDesc = value,
          ),
          SizedBox(height: 6),
          SizedBox(height: 6),

          SizedBox(height: 30),
          GradientElevatedButton(
            onPressed: () async {
              List<dynamic> oldPrices =
                  get<RoomViewModel>().updatedAdditionalPrices;
              Map<String, dynamic> newPrice = {
                "name": _priceName,
                "amount": _priceAmount,
                "description": _priceDesc,
              };

              oldPrices.add(newPrice);
              get<RoomViewModel>().updatedAdditionalPrices = oldPrices;
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
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
