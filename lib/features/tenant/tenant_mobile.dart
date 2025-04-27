// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/components/add_tenant.dart';
import 'package:frontend/features/tenant/components/tenant_card.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
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
      body:
          get<RoomViewModel>().tenants.isEmpty
              ? Center(child: Text("No tenants found"))
              : ListView.builder(
                itemCount: tenants.length,
                itemBuilder: (context, idx) {
                  final item = tenants[idx];
                  return TenantCard(item: item);
                },
              ),
      bottomNavigationBar: MobileNavbar(selectedindex: 2),
    );
  }
}
