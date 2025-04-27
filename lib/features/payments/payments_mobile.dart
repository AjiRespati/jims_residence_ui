import 'package:flutter/material.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class PaymentsMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  PaymentsMobile({super.key});

  @override
  State<PaymentsMobile> createState() => _PaymentsMobileState();
}

class _PaymentsMobileState extends State<PaymentsMobile> with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text("Finance")),
      bottomNavigationBar: MobileNavbar(selectedindex: 3),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue.shade700,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
