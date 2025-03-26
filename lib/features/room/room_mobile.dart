import 'package:flutter/material.dart';
import 'package:frontend/features/room/components/add_room.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';

import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomMobile extends StatelessWidget with GetItMixin {
  RoomMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          Text("Tambah Kamar"),
          SizedBox(width: 8),
          AddButton(
            size: 30,
            message: "Tambah Kamar",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
                context: context,
                builder: (context) {
                  return SizedBox(width: 600, child: AddRoom());
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body:
          watchOnly((RoomViewModel x) => x.isBusy)
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: get<RoomViewModel>().rooms.length,
                itemBuilder: (context, idx) {
                  var item = get<RoomViewModel>().rooms[idx];
                  print(item);
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {},
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              SizedBox(
                                width: 50,
                                child: Text(
                                  item['roomNumber'],
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Ukuran: "),
                                      Text(item['roomSize']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Status: "),
                                      Text(item['roomStatus']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Harga: "),
                                      Text("${item['basicPrice']}"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Ukuran: "),
                                      Text(item['roomSize']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Status: "),
                                      Text(item['roomStatus']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text("Harga: "),
                                      Text("${item['basicPrice']}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
