// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class KostMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  KostMobile({super.key});

  @override
  State<KostMobile> createState() => _KostMobileState();
}

class _KostMobileState extends State<KostMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    _snackbarGenerator(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kost"),
        actions: [
          if (watchOnly((RoomViewModel x) => x.isBusy))
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            ),
          SizedBox(width: 5),
          Text("Tambah Kost"),
          SizedBox(width: 8),
          AddButton(
            message: "",
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 24,
                      right: 24,
                      top: 24,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            'Tambah Kost',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade700,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(height: 6),
                          TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                              label: Text("Nama Kost"),
                            ),
                            onChanged:
                                (value) =>
                                    get<RoomViewModel>().kostName = value,
                          ),

                          SizedBox(height: 6),
                          TextFormField(
                            decoration: InputDecoration(
                              isDense: true,
                              label: Text("Alamat Kost"),
                            ),
                            onChanged:
                                (value) =>
                                    get<RoomViewModel>().kostAddress = value,
                          ),

                          SizedBox(height: 6),
                          TextFormField(
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                              isDense: true,
                              label: Text("Keterangan"),
                            ),
                            onChanged:
                                (value) =>
                                    get<RoomViewModel>().kostDescription =
                                        value,
                          ),
                          SizedBox(height: 30),
                          GradientElevatedButton(
                            onPressed: () async {
                              await get<RoomViewModel>().createKost();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Tambah Kost",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(width: 25),
        ],
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
                var item = get<RoomViewModel>().kosts[index];

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
      } else if (get<RoomViewModel>().isError) {
        _showSnackBar(
          get<RoomViewModel>().errorMessage ?? "Error",
          color: Colors.red.shade400,
          duration: Duration(seconds: 2),
        );
        get<RoomViewModel>().isError = false;
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
