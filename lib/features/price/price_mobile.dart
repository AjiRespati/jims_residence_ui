// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/features/price/components/add_room_price.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PriceMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PriceMobile({super.key});

  @override
  State<PriceMobile> createState() => _PriceMobileState();
}

class _PriceMobileState extends State<PriceMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.prices);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Price"),
        actions: [
          Text("Tambah Harga"),
          SizedBox(width: 8),
          AddButton(
            size: 30,
            message: "Tambah Harga",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(minHeight: 600, maxHeight: 620),
                context: context,
                builder: (context) {
                  return SizedBox(width: 600, child: AddRoomPrice());
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView.builder(
        itemCount: get<RoomViewModel>().prices.length,
        itemBuilder: (context, idx) {
          var item = get<RoomViewModel>().prices[idx];
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  item['boardingHouseName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text(
                                  formatCurrency(item['amount']),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text(item['description']),
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
                                Navigator.pushNamed(
                                  context,
                                  roomSettingsRoute,
                                  arguments: item,
                                );
                                // }
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
      bottomNavigationBar: MobileNavbar(selectedindex: 3),
    );
  }
}
