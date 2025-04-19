// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/features/price/components/add_price.dart';
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
    _snackbarGenerator(context);
    return Scaffold(
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
                  return SizedBox(width: 600, child: AddPrice());
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
          get<RoomViewModel>().successMessage ?? "Berhasil",
          color: Colors.green.shade400,
          duration: Duration(seconds: 2),
        );
        get<RoomViewModel>().isSuccess = false;
        get<RoomViewModel>().successMessage = null;
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
