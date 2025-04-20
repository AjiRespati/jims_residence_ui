// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/view_models/system_view_model.dart';
import 'package:frontend/widgets/buttons/edit_button.dart';
import 'package:frontend/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SettingsMobile extends StatelessWidget with GetItMixin {
  SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user = watchOnly((SystemViewModel x) => x.isBusy);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),

        actions: [
          Text("Logout"),
          SizedBox(width: 5),
          EditButton(
            message: "Logout",
            onPressed: () async {
              get<SystemViewModel>().isBusy = true;
              bool isLogout = await get<SystemViewModel>().logout();
              if (isLogout) {
                get<SystemViewModel>().isBusy = false;
                Navigator.pushReplacementNamed(context, signInRoute);
              } else {
                get<SystemViewModel>().isBusy = false;
              }
            },
            altIcon: Icons.logout_rounded,
          ),
          SizedBox(width: 25),
        ],
      ),
      body:
          user != null
              ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    // Text("Username: ${model.username}"),
                    // Text("Name: ${model.name}"),
                    // Text("Level: ${model.level ?? 0}"),
                    SizedBox(height: 30),
                    Divider(),
                    watchOnly((SystemViewModel x) => x.isBusy)
                        ? Column(
                          children: [
                            SizedBox(height: 200),
                            Center(
                              child: SizedBox(
                                width: 35,
                                height: 35,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        )
                        // : ((model.level ?? 0) > 3)
                        : true
                        ? Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, kostRoute);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Kost"),

                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, kostRoute);
                                    },
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),

                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  roomRoute,
                                  arguments: true,
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Room Management"),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        roomRoute,
                                        arguments: true,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),

                            // InkWell(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, priceRoute);
                            //   },
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text("Price Management"),
                            //       IconButton(
                            //         onPressed: () {
                            //           Navigator.pushNamed(context, priceRoute);
                            //         },
                            //         icon: Icon(
                            //           Icons.chevron_right_rounded,
                            //           size: 30,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Divider(),

                            // InkWell(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, homeRoute);
                            //   },
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text("Product Management"),
                            //       IconButton(
                            //         onPressed: () {
                            //           Navigator.pushNamed(context, homeRoute);
                            //         },
                            //         icon: Icon(
                            //           Icons.chevron_right_rounded,
                            //           size: 30,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Divider(),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, homeRoute);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Percentages Management"),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, homeRoute);
                                    },
                                    icon: Icon(
                                      Icons.chevron_right_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                          ],
                        )
                        : SizedBox(),

                    // GradientElevatedButton(
                    //   onPressed: () async {
                    //     get<SystemViewModel>().isBusy = true;
                    //     bool isLogout = await get<SystemViewModel>().logout();
                    //     if (isLogout) {
                    //       get<SystemViewModel>().isBusy = false;
                    //       Navigator.pushReplacementNamed(context, signInRoute);
                    //     } else {
                    //       get<SystemViewModel>().isBusy = false;
                    //     }
                    //   },
                    //   child: Text(
                    //     "Logout",
                    //     style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
              : SizedBox(),
      bottomNavigationBar: MobileNavbar(),
    );
  }
}
