import 'package:flutter/material.dart';
import 'package:frontend/features/room/components/add_price.dart';
import 'package:frontend/features/room/components/edit_room_status.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/buttons/edit_button.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';

import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomSettingsMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomSettingsMobile({super.key});

  @override
  State<RoomSettingsMobile> createState() => _RoomSettingsMobileState();
}

class _RoomSettingsMobileState extends State<RoomSettingsMobile>
    with GetItStateMixin {
  dynamic _room;
  dynamic _kost;
  dynamic _tenant;
  dynamic _payment;
  List<dynamic> _additionalPrices = [];

  _setup() async {
    await get<RoomViewModel>().fetchRoom();
    _room = get<RoomViewModel>().room;
    _kost = _room['BoardingHouse'];
    _tenant = _room['latestTenant'];
    _payment = _tenant?['Payments'][0];
    _additionalPrices = _room['AdditionalPrices'];
    get<RoomViewModel>().updatedAdditionalPrices = _additionalPrices;
    // print(_room);
    // print(_tenant);
    // print(_payment);
    // print(_additionalPrices);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.isError);
    _snackbarGenerator(context);
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Pengaturan Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body:
          (_room == null)
              ? Column(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
              : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // Wrap the body with SingleChildScrollView
                      child: Column(
                        children: [
                          Text(
                            _kost['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Text(
                              _room['roomNumber'],
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Text(
                                "Total biaya tambahan: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                formatCurrency(
                                  0,
                                  // _room['totalPrice'] - _room['basicPrice'],
                                ),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 4),
                          Row(
                            children: [
                              SizedBox(width: 20),
                              Text("Biaya tambahan (bulanan)"),
                              Spacer(),
                              SizedBox(width: 20),
                              AddButton(
                                message: "",
                                onPressed: () async {
                                  await showModalBottomSheet(
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
                                              MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                        ),
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            width: 600,
                                            child: AddPrice(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount:
                                      get<RoomViewModel>()
                                          .updatedAdditionalPrices
                                          .length,
                                  itemBuilder: (context, index) {
                                    var item =
                                        get<RoomViewModel>()
                                            .updatedAdditionalPrices[index];
                                    return Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text("- ${item['name']}: "),
                                        SizedBox(width: 10),
                                        Text(
                                          formatCurrency(item['amount']),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 20),
                              Text(
                                "Status Kamar: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _room['roomStatus'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Spacer(),
                              SizedBox(width: 20),
                              EditButton(
                                size: 34,
                                message: "",
                                onPressed: () {
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
                                              MediaQuery.of(
                                                context,
                                              ).viewInsets.bottom,
                                        ),
                                        child: SingleChildScrollView(
                                          child: SizedBox(
                                            width: 600,
                                            child: EditRoomStatus(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GradientElevatedButton(
                            buttonHeight: 30,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Batalkan",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                          GradientElevatedButton(
                            gradient: LinearGradient(
                              colors: [
                                Colors.greenAccent.shade400,
                                Colors.greenAccent.shade700,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            buttonHeight: 30,
                            onPressed: () async {
                              await get<RoomViewModel>().updateRoom();
                              setState(() {});
                            },
                            child: Text(
                              "Terapkan",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
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
          "Tambah penghuni baru berhasil",
          color: Colors.green.shade400,
          duration: Duration(seconds: 6),
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
