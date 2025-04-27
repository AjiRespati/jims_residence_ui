import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/components/add_tenant.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomDetailContent extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomDetailContent({super.key});

  @override
  State<RoomDetailContent> createState() => _RoomDetailContentState();
}

class _RoomDetailContentState extends State<RoomDetailContent>
    with GetItStateMixin {
  dynamic _room;
  dynamic _kost;
  dynamic _tenant;
  dynamic _payments;
  dynamic _payment;

  _setup() async {
    await get<RoomViewModel>().fetchRoom();
    _room = get<RoomViewModel>().room;
    _kost = _room['BoardingHouse'];
    _tenant = _room['latestTenant'];
    _payments = _tenant?['Payments'];
    // _payment = _tenant?['Payments'][0];
    // _additionalPrices = _room['AdditionalPrices'];

    // print(_room);
    // print(_tenant);
    // print(_payments);
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
    return _room == null
        ? SizedBox()
        : Column(
          children: [
            Row(
              children: [
                Text(
                  _kost['name'],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              child: Text(
                _room['roomNumber'],
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),
            Expanded(
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Ukuran: "),
                          Text(
                            _room['Price']['roomSize'] ?? " -",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Status: "),
                          Text(
                            _room['roomStatus'] ?? " -",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: generateRoomStatusColor(
                                roomSatus: _room['roomStatus'],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Harga: "),
                          Text(
                            formatCurrency(_room['Price']['amount']),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      if ((_room['AdditionalPrices'] ?? []).length != 0)
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text("Tambahan biaya: "),
                          ],
                        ),
                      if ((_room['AdditionalPrices'] ?? []).length != 0)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (_room['AdditionalPrices'] ?? []).length,
                          itemBuilder: (context, index) {
                            dynamic item = _room['AdditionalPrices'][index];
                            return Row(
                              children: [
                                SizedBox(width: 40),
                                Text(item['name'] + ": "),
                                SizedBox(width: 10),
                                Text(
                                  formatCurrency(item['amount']),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            );
                          },
                        ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(
                            "Total: ",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            formatCurrency(_room['totalPrice']),
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.greenAccent.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      if (_tenant != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text("Penghuni: "),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Nama: "),
                                SizedBox(width: 4),
                                Text(
                                  (_tenant?['name'] ?? " -"),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Telepon: "),
                                SizedBox(width: 4),
                                Text(
                                  (_tenant?['phone'] ?? " -"),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("NIK: "),
                                SizedBox(width: 4),
                                Text(
                                  (_tenant?['NIKNumber'] ?? " -"),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Fotocopy KTP: "),
                                SizedBox(width: 4),
                                Text(
                                  (_tenant?['isNIKCopyDone'] ?? false)
                                      ? "Sudah"
                                      : "Belum",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Mulai: "),
                                SizedBox(width: 4),
                                Text(
                                  formatDateString(_tenant['startDate']),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Selesai: "),
                                SizedBox(width: 4),
                                Text(
                                  formatDateString(_tenant['endDate']),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Batas pembayaran: "),
                                SizedBox(width: 4),
                                Text(
                                  formatDateString(_tenant['dueDate']),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 40),
                                Text("Batas tinggal: "),
                                SizedBox(width: 4),
                                Text(
                                  formatDateString(_tenant['banishDate']),
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      if (_payments != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text("Pembayaran: "),
                              ],
                            ),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _payments.length,
                              itemBuilder: (context, index) {
                                var payment = _payments[index];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(width: 40),
                                        Text(
                                          formatCurrency(
                                            payment['totalAmount'],
                                          ),
                                        ),
                                        Text(
                                          payment['paymentStatus']
                                              .toUpperCase(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(width: 40),
                                        Text(payment['description']),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),

                            Divider(),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (_tenant == null)
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GradientElevatedButton(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onPressed: () async {
                        get<RoomViewModel>().roomId = _room?['id'] ?? "";

                        await showModalBottomSheet(
                          isScrollControlled: true,
                          constraints: BoxConstraints(
                            minHeight: 490,
                            maxHeight: 750,
                          ),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: SizedBox(width: 400, child: AddTenant()),
                              ),
                            );
                          },
                        );
                        _setup();
                      },
                      child: Text(
                        "Daftarkan Penghuni Baru",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (watchOnly((RoomViewModel x) => x.isBusy))
                    Row(
                      children: [
                        SizedBox(width: 20),
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

            // if (_tenant != null)
            //   Stack(
            //     alignment: AlignmentDirectional.center,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: GradientElevatedButton(
            //           inactiveDelay: Duration.zero,
            //           onPressed: () async {
            //             await showModalBottomSheet(
            //               isScrollControlled: true,
            //               constraints: BoxConstraints(
            //                 minHeight: 490,
            //                 maxHeight: 700,
            //               ),
            //               context: context,
            //               builder: (context) {
            //                 return Padding(
            //                   padding: EdgeInsets.only(
            //                     bottom:
            //                         MediaQuery.of(context).viewInsets.bottom,
            //                   ),
            //                   child: SingleChildScrollView(
            //                     child: SizedBox(width: 400, child: AddTenant()),
            //                   ),
            //                 );
            //               },
            //             );
            //             _setup();
            //           },
            //           child: Text(
            //             "Update Kamar",
            //             style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.w600,
            //             ),
            //           ),
            //         ),
            //       ),
            //       if (watchOnly((RoomViewModel x) => x.isBusy))
            //         Row(
            //           children: [
            //             SizedBox(width: 20),
            //             SizedBox(
            //               width: 20,
            //               height: 20,
            //               child: Center(
            //                 child: CircularProgressIndicator(
            //                   color: Colors.grey[300],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //     ],
            //   ),
          ],
        );
  }
}
