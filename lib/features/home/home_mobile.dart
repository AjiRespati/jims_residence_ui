import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/view_models/room_view_model.dart';

import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class HomeMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isNoSession);
    watchOnly((RoomViewModel x) => x.kosts);
    _snackbarGenerator(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Residenza",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        children: [
          Divider(),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: get<RoomViewModel>().kosts.length,
              itemBuilder: (context, index) {
                final item = get<RoomViewModel>().kosts[index];
                print(item);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item['name'],
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item['address'],
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                item['description'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
          "Tambah kost berhasil",
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
