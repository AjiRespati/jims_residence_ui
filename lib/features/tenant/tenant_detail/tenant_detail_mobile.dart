// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/payments/components/create_other_cost_content.dart';
import 'package:residenza/features/payments/components/invoice_card.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_image.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_info.dart';
import 'package:residenza/view_models/room_view_model.dart';
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
      appBar: AppBar(title: Text("Detail Penghuni")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (_tenant == null) Center(child: Text("waiting for data...")),
            if (_tenant != null)
              Text(
                "${_tenant['boardingHouseName']} ${_tenant['roomNumber']}",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            if (_tenant != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TenantImage(tenant: _tenant),

                      SizedBox(height: 10),
                      Divider(),
                      SizedBox(height: 10),

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
                      Text(
                        "Daftar Tagihan",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          extendedPadding: EdgeInsets.symmetric(horizontal: 10),
          label: Text(
            "Biaya Lain",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color.fromARGB(200, 211, 47, 47),
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
                    child: CreateOtherCostContent(roomId: _tenant['roomId']),
                  ),
                );
              },
            );
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
