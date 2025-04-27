// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:residenza/features/tenant/components/add_tenant.dart';
import 'package:residenza/features/tenant/components/tenant_card.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/buttons/add_button.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class TenantMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  TenantMobile({super.key});

  @override
  State<TenantMobile> createState() => _TenantMobileState();
}

class _TenantMobileState extends State<TenantMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    final tenants = watchOnly((RoomViewModel x) => x.tenants);
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Penghuni",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        // actions: [
        //   Text("Tambah Tenant"),
        //   SizedBox(width: 8),
        //   AddButton(
        //     size: 30,
        //     message: "Tambah Tenant",
        //     onPressed: () {
        //       showModalBottomSheet(
        //         isScrollControlled: true,
        //         constraints: BoxConstraints(minHeight: 440, maxHeight: 450),
        //         context: context,
        //         builder: (context) {
        //           return Padding(
        //             padding: EdgeInsets.only(
        //               bottom: MediaQuery.of(context).viewInsets.bottom,
        //             ),
        //             child: SingleChildScrollView(
        //               child: SizedBox(width: 600, child: AddTenant()),
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        //   SizedBox(width: 20),
        // ],
      ),
      body: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Pilih Kost"),
                    value: get<RoomViewModel>().roomKostName,
                    items:
                        get<RoomViewModel>().kosts.map((item) {
                          return DropdownMenuItem<String>(
                            value: item['name'],
                            child: Text(item['name']),
                          );
                        }).toList(),
                    onChanged: (value) {
                      get<RoomViewModel>().roomKostName = value;
                      var item =
                          get<RoomViewModel>().kosts
                              .where((el) => el['name'] == value)
                              .toList()
                              .first;
                      get<RoomViewModel>().roomKostId = item['id'];
                    },
                  ),
                ),
              ],
            ),
          ),
          get<RoomViewModel>().tenants.isEmpty
              ? Center(child: Text("No tenants found"))
              : Expanded(
                child: ListView.builder(
                  itemCount: tenants.length,
                  itemBuilder: (context, idx) {
                    final item = tenants[idx];
                    return TenantCard(item: item);
                  },
                ),
              ),
        ],
      ),
      // get<RoomViewModel>().tenants.isEmpty
      //     ? Center(child: Text("No tenants found"))
      //     : ListView.builder(
      //       itemCount: tenants.length,
      //       itemBuilder: (context, idx) {
      //         final item = tenants[idx];
      //         return TenantCard(item: item);
      //       },
      //     ),
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
