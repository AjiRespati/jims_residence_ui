// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/room/components/add_price.dart';
import 'package:residenza/features/room/components/edit_room_status.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/add_button.dart';
import 'package:residenza/widgets/buttons/edit_button.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/buttons/remove_button.dart';
import 'package:residenza/widgets/page_container.dart';

class RoomSettingsDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomSettingsDesktop({super.key});

  @override
  State<RoomSettingsDesktop> createState() => _RoomSettingsDesktopState();
}

class _RoomSettingsDesktopState extends State<RoomSettingsDesktop>
    with GetItStateMixin {
  String _initialStatus = "";
  dynamic _room;
  dynamic _kost;
  // dynamic _tenant;
  // dynamic _payment;
  double _totalAdditionalPrice = 0;

  _setup(bool isInit) async {
    await get<RoomViewModel>().fetchRoom();
    _room = get<RoomViewModel>().room;
    _kost = _room['BoardingHouse'];
    // _tenant = _room['latestTenant'];
    // _payment = _tenant?['Payments'][0];
    get<RoomViewModel>().updatedAdditionalPrices = _room['AdditionalPrices'];
    _initialStatus = _room['roomStatus'] ?? "";
    get<RoomViewModel>().roomStatus = _room['roomStatus'];
    _totalAdditionalPrice = 0;
    for (var el in get<RoomViewModel>().updatedAdditionalPrices) {
      _totalAdditionalPrice = _totalAdditionalPrice + el['amount'].toDouble();
    }

    // print(_room);
    // print(_tenant);
    // print(_payment);
    // print(_additionalPrices);

    if (isInit) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setup(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child:
              (_room == null)
                  ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      ),
                    ],
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            children: [
                              SizedBox(width: 20),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(Icons.arrow_back_ios_new, size: 25),
                              ),
                              Text(
                                "Pengaturan Kamar",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Expanded(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          formatCurrency(_totalAdditionalPrice),
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
                                              // constraints: BoxConstraints(
                                              //   minHeight: 440,
                                              //   maxHeight: 450,
                                              // ),
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

                                            _totalAdditionalPrice = 0;
                                            for (var el
                                                in get<RoomViewModel>()
                                                    .updatedAdditionalPrices) {
                                              _totalAdditionalPrice =
                                                  _totalAdditionalPrice +
                                                  el['amount'].toDouble();
                                            }
                                            setState(() {});
                                          },
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: 20),
                                        Expanded(
                                          flex: 2,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
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
                                                    formatCurrency(
                                                      item['amount'],
                                                    ),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 20),
                                                  RemoveButton(
                                                    toolTip: "Hapus biaya?",
                                                    size: 18,
                                                    onPressed: () {
                                                      get<RoomViewModel>()
                                                          .updatedAdditionalPrices
                                                          .remove(item);

                                                      _totalAdditionalPrice = 0;
                                                      for (var el
                                                          in get<
                                                                RoomViewModel
                                                              >()
                                                              .updatedAdditionalPrices) {
                                                        _totalAdditionalPrice =
                                                            _totalAdditionalPrice +
                                                            el['amount']
                                                                .toDouble();
                                                      }
                                                      setState(() {});
                                                    },
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          _initialStatus,
                                          // watchOnly((RoomViewModel x) => x.roomStatus) ??
                                          //     "",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: generateRoomStatusColor(
                                              roomSatus: _initialStatus,
                                              // roomSatus: watchOnly(
                                              //   (RoomViewModel x) => x.roomStatus,
                                              // ),
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(width: 20),
                                        EditButton(
                                          size: 34,
                                          message: "",
                                          onPressed: () async {
                                            final result =
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
                                                          child: EditRoomStatus(
                                                            oldStatus:
                                                                _initialStatus,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                            if (result == true) {
                                              setState(() {
                                                _initialStatus =
                                                    get<RoomViewModel>()
                                                        .roomStatus ??
                                                    "";
                                              });
                                              get<RoomViewModel>().fetchRooms(
                                                boardingHouseId:
                                                    get<RoomViewModel>()
                                                        .roomKostId,
                                                dateFrom: null,
                                                dateTo: null,
                                              );
                                            }
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GradientElevatedButton(
                                      buttonHeight: 30,
                                      onPressed: () async {
                                        await get<RoomViewModel>().fetchRooms(
                                          boardingHouseId:
                                              get<RoomViewModel>().roomKostId,
                                          dateFrom: null,
                                          dateTo: null,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Kembali",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
        ),
      ),
    );
  }
}
