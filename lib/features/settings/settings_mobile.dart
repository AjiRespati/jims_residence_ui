// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:residenza/application_info.dart';
import 'package:residenza/features/settings/components/truncate_table.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:residenza/widgets/mobile_navbar.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SettingsMobile extends StatelessWidget with GetItMixin {
  SettingsMobile({super.key});

  @override
  Widget build(BuildContext context) {
    dynamic user = watchOnly((SystemViewModel x) => x.isBusy);
    SystemViewModel model = get<SystemViewModel>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Settings"),

        actions: [
          Text("Logout"),
          SizedBox(width: 5),
          IconButton(
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
            icon: Icon(Icons.logout_rounded, color: Colors.blue.shade800),
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
                    Text(
                      "Username: ${model.username}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Level: ${model.level}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.levelDesc,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Status: ${model.status}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        : (model.level > 0)
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
                                Navigator.pushNamed(context, userRoute);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("User Management"),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, userRoute);
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

                            if (ApplicationInfo.isDevelOn &&
                                (model.username == 'aji@mail.com' ||
                                    model.username ==
                                        'aji.b.respati@gmail.com'))
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
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
                                          child: TruncateTable(),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Developers"),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chevron_right_rounded,
                                        size: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (ApplicationInfo.isDevelOn &&
                                (model.username == 'aji@mail.com' ||
                                    model.username ==
                                        'aji.b.respati@gmail.com'))
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
      bottomNavigationBar: MobileNavbar(
        selectedindex: get<SystemViewModel>().user['level'] < 1 ? 2 : 4,
      ),
    );
  }
}
