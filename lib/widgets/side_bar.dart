import 'package:flutter/material.dart';
import '../../application_info.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class SideBar extends StatelessWidget with GetItMixin {
  SideBar({required this.onTapMenu, super.key});

  final Function({String? menuTitle}) onTapMenu;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      elevation: 1,
      color: Colors.white,
      child: SizedBox(
        height: size.height,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
              child: Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          Text(
                            ApplicationInfo.appName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(child: SizedBox()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home, size: 22),
                    title: const Text("Beranda"),
                    dense: true,
                    onTap: () {
                      onTapMenu(menuTitle: "Beranda");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.door_sliding, size: 22),
                    title: const Text("Kamar"),
                    dense: true,
                    onTap: () {
                      onTapMenu(menuTitle: "Kamar");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people, size: 22),
                    title: const Text("Penghuni"),
                    dense: true,
                    onTap: () {
                      onTapMenu(menuTitle: "Penghuni");
                    },
                    // trailing: const Icon(Icons.keyboard_arrow_down, size: 24),
                  ),
                  ListTile(
                    leading: const Icon(Icons.payments, size: 22),
                    // leading: const Icon(Icons.bar_chart_rounded, size: 22),
                    title: const Text("Transaksi"),
                    dense: true,
                    onTap: () {
                      onTapMenu(menuTitle: "Transaksi");
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, size: 22),
                    // leading: const Icon(Icons.bar_chart_rounded, size: 22),
                    title: const Text("Pengaturan"),
                    dense: true,
                    onTap: () {
                      onTapMenu(menuTitle: "Pengaturan");
                    },
                  ),
                  const Column(children: []),
                ],
              ),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, size: 18),
              title: const Text('Logout'),
              onTap: () {
                // get<AuthViewModel>().handleSignOut(context: context);
              },
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
