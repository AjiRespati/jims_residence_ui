// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/features/payments/components/create_other_cost_content.dart';
import 'package:residenza/features/payments/components/invoice_card.dart';
import 'package:residenza/features/tenant/components/tenant_checkout_content.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_image.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_info.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/page_container.dart';

class TenantDetailDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantDetailDesktop({super.key});

  @override
  State<TenantDetailDesktop> createState() => _TenantDetailDesktopState();
}

class _TenantDetailDesktopState extends State<TenantDetailDesktop>
    with GetItStateMixin {
  dynamic _tenant;

  String _name = "";
  String _phone = "";
  String _nik = "";
  String _status = "";
  DateTime? _startDate;
  DateTime? _endDate;

  Future _setup() async {
    await get<RoomViewModel>().fetchTenant();
    setState(() {
      _tenant = get<RoomViewModel>().tenant;
    });

    _name = _tenant['name'];
    _phone = _tenant['phone'];
    _nik = _tenant['NIKNumber'];
    _status = _tenant['tenancyStatus'];

    _startDate =
        _tenant['startDate'] == null
            ? null
            : DateTime.parse(_tenant['startDate']);

    _endDate =
        _tenant['endDate'] == null ? null : DateTime.parse(_tenant['endDate']);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setup();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageContainer(
        setSidebarExpanding: true,
        showMenubutton: true,
        mainSection: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new, size: 25),
                      ),
                      Text(
                        "Detail Penghuni",
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
                flex: 4,
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (_tenant == null)
                          Center(child: Text("waiting for data...")),
                        if (_tenant != null)
                          Text(
                            "${_tenant['boardingHouseName']} ${_tenant['roomNumber']}",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        if (_tenant != null)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TenantImage(tenant: _tenant),

                                  Divider(),

                                  TenantInfo(
                                    id: _tenant['id'],
                                    name: _name,
                                    phone: _phone,
                                    nik: _nik,
                                    status: _status,
                                    startDate: _startDate,
                                    endDate: _endDate,
                                  ),

                                  SizedBox(height: 10),
                                  Stack(
                                    alignment: Alignment.centerRight,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Daftar Tagihan",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      GradientElevatedButton(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(240, 244, 67, 54),
                                            Color.fromRGBO(241, 30, 30, 0.641),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        elevation: 8,
                                        buttonHeight: 25,
                                        onPressed: () async {
                                          await showModalBottomSheet(
                                            isScrollControlled: true,
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
                                                  child: CreateOtherCostContent(
                                                    roomId: _tenant['roomId'],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                          _setup();
                                        },
                                        child: Text(
                                          "Biaya Lain",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  //TODO: TENANT PAYMENTS LIST
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: _tenant?['Invoices'].length,
                                    itemBuilder: (context, index) {
                                      final item = _tenant['Invoices'][index];
                                      item['Tenant'] = {'id': _tenant['id']};
                                      return InvoiceCard(item: item);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80, left: 20),
        child: SizedBox(
          height: 40,
          child: FloatingActionButton.extended(
            extendedPadding: EdgeInsets.symmetric(horizontal: 10),
            label: Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color.fromARGB(200, 33, 149, 243),
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: TenantCheckoutContent(
                        tenantId: _tenant['id'],
                        name: _name,
                        boardingHouseName: _tenant['boardingHouseName'],
                      ),
                    ),
                  );
                },
              );
              if (get<RoomViewModel>().isSuccess) {
                Navigator.pushNamed(context, roomRoute, arguments: false);
              }
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
