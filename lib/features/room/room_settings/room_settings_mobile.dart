import 'package:flutter/material.dart';
import 'package:frontend/features/room/components/add_price.dart';
import 'package:frontend/features/room/components/edit_room_status.dart';
import 'package:frontend/utils/helpers.dart';
import 'package:frontend/view_models/room_view_model.dart';
import 'package:frontend/widgets/buttons/add_button.dart';
import 'package:frontend/widgets/buttons/edit_button.dart';

import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class RoomSettingsMobile extends StatelessWidget with GetItMixin {
  RoomSettingsMobile({super.key});
  // final dynamic datas;

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) => x.room);
    dynamic datas = get<RoomViewModel>().room;
    return Scaffold(
      resizeToAvoidBottomInset: true, // Add this line
      appBar: AppBar(
        title: Text(
          "Pengaturan Kamar",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body:
          (datas == null)
              ? Column(
                children: [
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
              : SingleChildScrollView(
                // Wrap the body with SingleChildScrollView
                child: Column(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        datas['roomNumber'],
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Biaya Tambahan: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formatCurrency(
                            datas['totalPrice'] - datas['basicPrice'],
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        SizedBox(width: 20),
                        AddButton(
                          message: "",
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                minHeight: 440,
                                maxHeight: 450,
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
                                      child: AddPrice(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 60,
                            child: ListView.builder(
                              itemCount: datas['AdditionalPrices'].length,
                              itemBuilder: (context, index) {
                                var item = datas['AdditionalPrices'][index];
                                return Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Text("- ${item['name']}:"),
                                    SizedBox(width: 10),
                                    Text(formatCurrency(item['amount'])),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 20),
                        Text(
                          "Status Kamar: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          datas['roomStatus'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Spacer(),
                        SizedBox(width: 20),
                        EditButton(
                          size: 34,
                          message: "",
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              constraints: BoxConstraints(
                                minHeight: 440,
                                maxHeight: 450,
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
                                      child: EditRoomStatus(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
