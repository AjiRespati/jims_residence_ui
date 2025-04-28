// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/features/room/components/room_detail_content.dart';
import 'package:residenza/utils/helpers.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomDetailMobile extends StatefulWidget with GetItStatefulWidgetMixin {
  RoomDetailMobile({super.key});

  @override
  State<RoomDetailMobile> createState() => _RoomDetailMobileState();
}

class _RoomDetailMobileState extends State<RoomDetailMobile>
    with GetItStateMixin {
  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.isError);
    watchOnly((RoomViewModel x) => x.isSuccess);
    if (mounted) {
      snackbarGenerator(context, get<RoomViewModel>());
    }
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Detail Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: RoomDetailContent(),
      ),
      bottomNavigationBar: MobileNavbar(selectedindex: 1),
    );
  }
}
