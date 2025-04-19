// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/components/add_tenant.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomDetailMobile extends StatelessWidget with GetItMixin {
  RoomDetailMobile({required this.datas, super.key});

  final dynamic datas;

  @override
  Widget build(BuildContext context) {
    print(datas);
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Detail Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    datas['BoardingHouse']['name'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
                child: Text(
                  datas['roomNumber'],
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
                ),
              ),
              Divider(),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text("Ukuran: "),
                  Text(datas['Price']['roomSize'] ?? " -"),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text("Status: "),
                  Text(datas['roomStatus'] ?? " -"),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Text("Harga: "),
                  Text(formatCurrency(datas['Price']['amount'])),
                ],
              ),
              if ((datas['AdditionalPrices'] ?? []).length != 0)
                Row(children: [SizedBox(width: 20), Text("Tambahan harga: ")]),
              if ((datas['AdditionalPrices'] ?? []).length != 0)
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: (datas['AdditionalPrices'] ?? []).length,
                    itemBuilder: (context, index) {
                      dynamic item = datas['AdditionalPrices'][index];
                      return Text("data");
                    },
                  ),
                ),
              Divider(),
              Row(children: [SizedBox(width: 20), Text("Penghuni: ")]),
              Row(
                children: [
                  SizedBox(width: 60),
                  Text("Nama: "),
                  Text((datas['latestTenant']?['name'] ?? " -")),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 60),
                  Text("Telepon: "),
                  Text((datas['latestTenant']?['phone'] ?? " -")),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 60),
                  Text("NIK: "),
                  Text((datas['latestTenant']?['idNumber'] ?? " -")),
                ],
              ),
              Row(
                children: [
                  SizedBox(width: 60),
                  Text("Fotocopy KTP: "),
                  Text(
                    (datas['latestTenant']?['isIdCopyDone'] ?? false)
                        ? "Sudah"
                        : "Belum",
                  ),
                ],
              ),
              SizedBox(height: 100),
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GradientElevatedButton(
                      inactiveDelay: Duration.zero,
                      onPressed: () async {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            minHeight: 440,
                            maxHeight: 450,
                          ),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: SizedBox(width: 600, child: AddTenant()),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Daftarkan Penghuni Baru",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
        ),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
