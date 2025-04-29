// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/room/components/add_price.dart';
import 'package:residenza/features/tenant/components/add_tenant.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/add_button.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/widgets/buttons/remove_button.dart';

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
  // dynamic _payment;
  double _totalAdditionalPrice = 0;
  double _priceAmount = 0;

  _setup() async {
    await get<RoomViewModel>().fetchRoom();
    _room = get<RoomViewModel>().room;
    _kost = _room['BoardingHouse'];
    _tenant = _room['latestTenant'];
    _payments = _tenant?['Payments'];
    // _payment = _tenant?['Payments'][0];
    // _additionalPrices = _room['AdditionalPrices'];

    print(_room);
    // print(_tenant);
    // print(_payments);
    // print(_additionalPrices);

    get<RoomViewModel>().updatedAdditionalPrices = _room['AdditionalPrices'];
    get<RoomViewModel>().roomStatus = _room['roomStatus'];
    _totalAdditionalPrice = 0;
    for (var el in get<RoomViewModel>().updatedAdditionalPrices) {
      _totalAdditionalPrice = _totalAdditionalPrice + el['amount'].toDouble();
    }

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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
            ),
            Divider(),

            if (_tenant == null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AddTenant(),
                      Divider(),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            label: Text("Harga kamar"),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged:
                              (value) => _priceAmount = double.parse(value),
                        ),
                      ),
                      SizedBox(height: 6),
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
                                            in get<RoomViewModel>()
                                                .updatedAdditionalPrices) {
                                          _totalAdditionalPrice =
                                              _totalAdditionalPrice +
                                              el['amount'].toDouble();
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
                      SizedBox(height: 50),
                      if (_tenant == null)
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: GradientElevatedButton(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                onPressed: () async {
                                  get<RoomViewModel>().roomId =
                                      _room?['id'] ?? "";
                                  get<RoomViewModel>().tenantStatus = "Active";
                                  get<RoomViewModel>().priceAmount =
                                      _priceAmount;
                                  await get<RoomViewModel>().addTenant();
                                  Navigator.pushNamed(
                                    context,
                                    roomRoute,
                                    arguments: false,
                                  );

                                  // await showModalBottomSheet(
                                  //   isScrollControlled: true,
                                  //   constraints: BoxConstraints(
                                  //     minHeight: 490,
                                  //     maxHeight: 750,
                                  //   ),
                                  //   context: context,
                                  //   builder: (context) {
                                  //     return Padding(
                                  //       padding: EdgeInsets.only(
                                  //         bottom:
                                  //             MediaQuery.of(context).viewInsets.bottom,
                                  //       ),
                                  //       child: SingleChildScrollView(
                                  //         child: SizedBox(width: 400, child: AddTenant()),
                                  //       ),
                                  //     );
                                  //   },
                                  // );
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
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            if (_tenant != null)
              Expanded(
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     SizedBox(width: 20),
                        //     Text("Ukuran: "),
                        //     Text(
                        //       _room['Price']?['roomSize'] ?? " -",
                        //       style: TextStyle(fontWeight: FontWeight.w600),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text("Status: ", style: TextStyle(fontSize: 14)),
                            Text(
                              _room['roomStatus'] ?? " -",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: generateRoomStatusColor(
                                  roomSatus: _room['roomStatus'],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2),
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text("Harga: "),
                            Text(
                              formatCurrency(_room['Price']?['amount'] ?? 0),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
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
