// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/features/room/components/add_room.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';

import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomMobile({required this.isSetting, super.key});
  final bool isSetting;

  @override
  State<RoomMobile> createState() => _RoomMobileState();
}

class _RoomMobileState extends State<RoomMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.rooms);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions:
            !widget.isSetting
                ? null
                : [
                  Text("Tambah Kamar"),
                  SizedBox(width: 8),
                  AddButton(
                    size: 30,
                    message: "Tambah Kamar",
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          minHeight: 600,
                          maxHeight: 620,
                        ),
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
      body: ListView.builder(
        itemCount: get<RoomViewModel>().rooms.length,
        itemBuilder: (context, idx) {
          dynamic item = get<RoomViewModel>().rooms[idx];
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: ClipRRect(
                child: InkWell(
                  onTap:
                      widget.isSetting
                          ? null
                          : () {
                            get<RoomViewModel>().roomId = item?['id'] ?? "";
                            Navigator.pushNamed(context, roomDetailRoute);
                          },
                  child: Banner(
                    message: item['roomStatus'],
                    textStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    location: BannerLocation.topEnd,
                    color: generateRoomStatusColor(
                      roomSatus: item['roomStatus'],
                    ),

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
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item['BoardingHouse']['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
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
                                  Text(formatCurrency(item['totalPrice'])),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Expanded(child: SizedBox()),
                          Column(
                            children: [
                              if (widget.isSetting)
                                IconButton(
                                  onPressed: () async {
                                    get<RoomViewModel>().roomId = item['id'];
                                    Navigator.pushNamed(
                                      context,
                                      roomSettingsRoute,
                                      arguments: item,
                                    );
                                  },
                                  icon: Icon(Icons.settings),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
