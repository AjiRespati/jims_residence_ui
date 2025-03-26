import 'package:flutter/material.dart';
import 'package:frontend/features/tenant/components/add_tenant.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';

class TenantMobile extends StatelessWidget {
  const TenantMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Tenant",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        actions: [
          Text("Tambah Tenant"),
          SizedBox(width: 8),
          AddButton(
            size: 30,
            message: "Tambah Tenant",
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                constraints: BoxConstraints(minHeight: 440, maxHeight: 450),
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(width: 600, child: AddTenant()),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        child: Column(
          children: [
            // Your existing content here.
            // if you have listview, gridview, or any other widget that contains many widget, put it inside this column.
          ],
        ),
      ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
