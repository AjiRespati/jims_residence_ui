// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/payments/components/create_other_cost_content.dart';
import 'package:residenza/features/payments/components/invoice_card.dart';
import 'package:residenza/features/tenant/components/contract_preview_dialog.dart';
import 'package:residenza/features/tenant/components/tenant_checkout_content.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_contract_image.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_image.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_info.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/gradient_elevated_button.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TenantDetailMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantDetailMobile({super.key});

  @override
  State<TenantDetailMobile> createState() => _TenantDetailMobileState();
}

class _TenantDetailMobileState extends State<TenantDetailMobile>
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
        _tenant['checkinDate'] == null
            ? null
            : DateTime.parse(_tenant['checkinDate']);

    _endDate =
        _tenant['checkoutDate'] == null
            ? null
            : DateTime.parse(_tenant['checkoutDate']);

    setState(() {});
  }

  Future _openContractPreview() async {
    final roomVm = get<RoomViewModel>();
    final previousRoomId = roomVm.roomId;
    roomVm.roomId = _tenant['roomId'];
    await roomVm.fetchRoom();
    final room = roomVm.room;
    roomVm.roomId = previousRoomId;

    await showDialog(
      context: context,
      builder: (context) => ContractPreviewDialog(
        tenant: Map<String, dynamic>.from(_tenant),
        room: room == null ? null : Map<String, dynamic>.from(room),
      ),
    );
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
      appBar: AppBar(title: Text("Detail Penghuni")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _tenant == null
            ? const Center(child: Text("waiting for data..."))
            : Column(
                children: [
                  Text(
                    "${_tenant['boardingHouseName']} ${_tenant['roomNumber']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 96),
                      children: [
                        TenantImage(tenant: _tenant, isMobile: true),
                        const Divider(),
                        TenantInfo(
                          id: _tenant['id'],
                          name: _name,
                          phone: _phone,
                          nik: _nik,
                          status: _status,
                          startDate: _startDate,
                          endDate: _endDate,
                        ),
                        const SizedBox(height: 10),

                        // TOMBOL KONTRAK SEWA
                        OutlinedButton.icon(
                          icon: const Icon(Icons.description_outlined, size: 18),
                          label: const Text(
                            "Kontrak Sewa",
                            style: TextStyle(fontSize: 12),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 32),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          onPressed: _openContractPreview,
                        ),
                        const SizedBox(height: 10),

                        TenantContractImage(tenant: _tenant, isMobile: true),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Daftar Tagihan",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            if (_status != 'Inactive')
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
                                          bottom: MediaQuery.of(
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
                                child: const Text(
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
                        const SizedBox(height: 10),

                        ...((_tenant['Invoices'] as List?) ?? const []).map((
                          item,
                        ) {
                          item['Tenant'] = {
                            'id': _tenant['id'],
                            'name': _tenant['name'],
                          };
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InvoiceCard(item: item, isMobile: true),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButtonLocation:
          _status == 'Inactive'
              ? null
              : FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton:
          _status == 'Inactive'
              ? null
              : SizedBox(
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
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
