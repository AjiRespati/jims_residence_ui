import 'package:flutter/material.dart';
import 'package:residenza/routes/route_names.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MobileNavbar extends StatelessWidget with GetItMixin {
  MobileNavbar({required this.selectedindex, super.key});
  final int selectedindex;

  @override
  Widget build(BuildContext context) {
    if (watchOnly((SystemViewModel x) => x.status) == "new") {
      return NavigationBar(
        onDestinationSelected: (value) {
          get<SystemViewModel>().currentPageIndex = value;
          switch (value) {
            case 0:
              Navigator.pushNamed(context, homeRoute);
              break;
            case 1:
              Navigator.pushNamed(context, roomRoute, arguments: false);
              break;
            default:
              Navigator.pushNamed(context, settingRoute);
              break;
          }
        },
        selectedIndex: selectedindex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.blue.shade800),
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.meeting_room_rounded,
              color: Colors.blue.shade800,
            ),
            icon: Icon(Icons.meeting_room_rounded),
            label: "Kamar",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, color: Colors.blue.shade800),
            icon: Icon(Icons.settings),
            label: "Pengaturan",
          ),
        ],
      );
    } else {
      return NavigationBar(
        onDestinationSelected: (value) {
          get<SystemViewModel>().currentPageIndex = value;
          switch (value) {
            case 0:
              Navigator.pushNamed(context, homeRoute);
              break;
            case 1:
              Navigator.pushNamed(context, roomRoute, arguments: false);
              break;
            case 2:
              Navigator.pushNamed(context, tenantRoute);
              break;
            case 3:
              Navigator.pushNamed(context, paymentsRoute);
              break;
            default:
              Navigator.pushNamed(context, settingRoute);
              break;
          }
        },
        selectedIndex: selectedindex,
        destinations: [
          NavigationDestination(
            selectedIcon: Icon(Icons.home, color: Colors.blue.shade800),
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.meeting_room_rounded,
              color: Colors.blue.shade800,
            ),
            icon: Icon(Icons.meeting_room_rounded),
            label: "Kamar",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.people_alt_rounded,
              color: Colors.blue.shade800,
            ),
            icon: Icon(Icons.people_alt_rounded),
            label: "Penghuni",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.payments_rounded,
              color: Colors.blue.shade800,
            ),
            icon: Icon(Icons.payments_rounded),
            label: "Transaksi",
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings, color: Colors.blue.shade800),
            icon: Icon(Icons.settings),
            label: "Pengaturan",
          ),
        ],
      );
    }
  }
}
