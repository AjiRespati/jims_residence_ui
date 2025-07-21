import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:residenza/view_models/room_view_model.dart';

class LandingDesktop extends StatefulWidget with GetItStatefulWidgetMixin {
  LandingDesktop({super.key});

  @override
  State<LandingDesktop> createState() => _LandingDesktopState();
}

class _LandingDesktopState extends State<LandingDesktop> with GetItStateMixin {
  ScrollController scrollControl = ScrollController();
  List<dynamic> _kosts = [];

  @override
  Widget build(BuildContext context) {
    watchOnly((RoomViewModel x) {
      _kosts = x.kosts;
      return x.kosts;
    });

    return Scaffold(
      body: Stack(
        children: [
          Scrollbar(
            controller: scrollControl,
            thumbVisibility: true,
            trackVisibility: true,
            thickness: 8,
            child: SingleChildScrollView(
              controller: scrollControl,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _kosts.length,
                    itemBuilder: (context, idx) {
                      if (idx % 2 != 0) {
                        return Column(
                          children: [
                            Row(children: [Text(_kosts[idx]['name'])]),
                            Row(
                              children: [
                                Text(_kosts[idx]['availableRoomsCount']),
                              ],
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          SizedBox(width: 50),
                          Column(
                            children: [
                              Text(_kosts[idx]['name']),
                              Row(
                                children: [
                                  Text(_kosts[idx]['availableRoomsCount']),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.2),
                ),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: Image.asset('logo/mini_logo.png'),
                  ),
                  SizedBox(
                    height: 54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "esidenza",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
