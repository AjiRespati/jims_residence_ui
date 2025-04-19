// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/components/add_tenant.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/gradient_elevated_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomDetailMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomDetailMobile({required this.datas, super.key});

  final dynamic datas;

  @override
  State<RoomDetailMobile> createState() => _RoomDetailMobileState();
}

class _RoomDetailMobileState extends State<RoomDetailMobile>
    with GetItStateMixin {
  dynamic data;
  dynamic tenant;
  dynamic payment;

  _setup() async {
    data = widget.datas;
    tenant = data['latestTenant'];
    payment = tenant?['Payments'][0];
    print(data);
    print(tenant);
    print(payment);
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
          "Detail Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              data == null
                  ? SizedBox()
                  : Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            data['BoardingHouse']['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 50,
                        child: Text(
                          data['roomNumber'],
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Ukuran: "),
                          Text(data['Price']['roomSize'] ?? " -"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Status: "),
                          Text(data['roomStatus'] ?? " -"),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text("Harga: "),
                          Text(formatCurrency(data['Price']['amount'])),
                        ],
                      ),
                      if ((data['AdditionalPrices'] ?? []).length != 0)
                        Row(
                          children: [
                            SizedBox(width: 20),
                            Text("Tambahan harga: "),
                          ],
                        ),
                      if ((data['AdditionalPrices'] ?? []).length != 0)
                        SizedBox(
                          height: 300,
                          child: ListView.builder(
                            itemCount: (data['AdditionalPrices'] ?? []).length,
                            itemBuilder: (context, index) {
                              dynamic item = data['AdditionalPrices'][index];
                              return Text("data");
                            },
                          ),
                        ),
                      Divider(),
                      if (tenant != null)
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
                                SizedBox(width: 60),
                                Text("Nama: "),
                                Text((tenant?['name'] ?? " -")),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 60),
                                Text("Telepon: "),
                                Text((tenant?['phone'] ?? " -")),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 60),
                                Text("NIK: "),
                                Text((tenant?['NIKNumber'] ?? " -")),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 60),
                                Text("Fotocopy KTP: "),
                                Text(
                                  (tenant?['isIdCopyDone'] ?? false)
                                      ? "Sudah"
                                      : "Belum",
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      if (payment != null)
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 20),
                                Text("Pembayaran: "),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      SizedBox(height: 100),

                      if (tenant == null)
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
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      minHeight: 490,
                                      maxHeight: 700,
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
                                            child: AddTenant(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
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

                      if (tenant != null)
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: GradientElevatedButton(
                                inactiveDelay: Duration.zero,
                                onPressed: () async {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    constraints: BoxConstraints(
                                      minHeight: 490,
                                      maxHeight: 700,
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
                                            child: AddTenant(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text(
                                  "Update Penghuni",
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
                    ],
                  ),
        ),
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
