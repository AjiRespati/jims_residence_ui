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
  RoomMobile({super.key});

  @override
  State<RoomMobile> createState() => _RoomMobileState();
}

class _RoomMobileState extends State<RoomMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.rooms);
    watchOnly((RoomViewModel x) => x.isError);
    _snackbarGenerator(context);
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
      body: ListView.builder(
        itemCount: get<RoomViewModel>().rooms.length,
        itemBuilder: (context, idx) {
          var item = get<RoomViewModel>().rooms[idx];
          print(item);
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    roomDetailRoute,
                    arguments: item,
                  );
                },
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
                                Text(item['Price']['roomSize']),
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
                                Text(formatCurrency(item['Price']['amount'])),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Text("Ukuran: "),
                        //         Text(item['roomSize']),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Text("Status: "),
                        //         Text(item['roomStatus']),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Text("Harga: "),
                        //         Text("${item['basicPrice']}"),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        Expanded(child: SizedBox()),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                get<RoomViewModel>().roomId = item['id'];
                                final go =
                                    await get<RoomViewModel>().fetchRoom();
                                if (go) {
                                  Navigator.pushNamed(
                                    context,
                                    roomSettingsRoute,
                                    arguments: item,
                                  );
                                }
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
          );
        },
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }

  void _snackbarGenerator(BuildContext context) {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      if (get<RoomViewModel>().isNoSession) {
        Navigator.pushNamed(context, signInRoute);
        get<RoomViewModel>().isNoSession = false;
      } else if (get<RoomViewModel>().isError == true) {
        _showSnackBar(
          get<RoomViewModel>().errorMessage ?? "Error",
          color: Colors.red.shade400,
          duration: Duration(seconds: 2),
        );
        get<RoomViewModel>().isError = null;
        get<RoomViewModel>().errorMessage = null;
      } else if (get<RoomViewModel>().isSuccess) {
        _showSnackBar(
          "Tambah room berhasil",
          color: Colors.green.shade400,
          duration: Duration(seconds: 2),
        );
        get<RoomViewModel>().isSuccess = false;
      }
    });
  }

  // Helper function to show SnackBars
  void _showSnackBar(
    String message, {
    Color color = Colors.blue,
    Duration duration = const Duration(seconds: 4),
  }) {
    // Ensure context is still valid before showing SnackBar
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: duration,
        ),
      );
    }
  }
}
