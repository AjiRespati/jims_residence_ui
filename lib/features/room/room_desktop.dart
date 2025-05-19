import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/room/components/add_room.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/buttons/add_button.dart';
import 'package:residenza/widgets/page_container.dart';

class RoomDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomDesktop({required this.isSetting, super.key});
  final bool isSetting;

  @override
  State<RoomDesktop> createState() => _RoomDesktopState();
}

class _RoomDesktopState extends State<RoomDesktop> with GetItStateMixin {
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.rooms);
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
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 20),
                        Flexible(
                          flex: 7,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: "Pilih Kost",
                              isDense: true,
                            ),
                            value: get<RoomViewModel>().roomKostName,
                            items:
                                get<RoomViewModel>().kosts.map((item) {
                                  final isSelected =
                                      item['name'] ==
                                      get<RoomViewModel>().roomKostName;

                                  return DropdownMenuItem<String>(
                                    value: item['name'],
                                    child: Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontWeight:
                                            isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                            onChanged: (value) async {
                              get<RoomViewModel>().roomKostName = value;
                              var item =
                                  get<RoomViewModel>().kosts
                                      .where((el) => el['name'] == value)
                                      .toList()
                                      .first;
                              get<RoomViewModel>().roomKostId = item['id'];
                              await get<RoomViewModel>().fetchRooms(
                                boardingHouseId: item['id'],
                                dateFrom: _dateFrom,
                                dateTo: _dateTo,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: Row(
                            children:
                                !widget.isSetting
                                    ? []
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
                                              return SizedBox(
                                                width: 600,
                                                child: AddRoom(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(width: 20),
                                    ],
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: get<RoomViewModel>().rooms.length,
                  itemBuilder: (context, idx) {
                    dynamic item = get<RoomViewModel>().rooms[idx];
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 8,
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: ClipRRect(
                          child: InkWell(
                            onTap:
                                widget.isSetting ||
                                        (get<SystemViewModel>()
                                                .user['status'] ==
                                            'new')
                                    ? null
                                    : () {
                                      get<RoomViewModel>().roomId =
                                          item?['id'] ?? "";
                                      Navigator.pushNamed(
                                        context,
                                        roomDetailRoute,
                                      );
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        // Row(
                                        //   children: [
                                        //     Text("Ukuran: "),
                                        //     Text(item?['roomSize'] ?? " -"),
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            Text("Status: "),
                                            Text(item['roomStatus']),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Harga: "),
                                            Text(
                                              formatCurrency(
                                                item['totalPrice'],
                                              ),
                                            ),
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
                                              get<RoomViewModel>().roomId =
                                                  item['id'];
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
