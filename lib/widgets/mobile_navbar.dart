import 'package:flutter/material.dart';
import 'package:frontend/routes/route_names.dart';
import 'package:frontend/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MobileNavbar extends StatelessWidget with GetItMixin {
  MobileNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (value) {
        get<SystemViewModel>().currentPageIndex = value;
        switch (value) {
          case 0:
            Navigator.pushNamed(context, homeRoute);
            break;
          case 1:
            Navigator.pushNamed(context, roomRoute);
            break;
          case 2:
            Navigator.pushNamed(context, tenantRoute);
            break;
          case 3:
            Navigator.pushNamed(context, paymentsRoute);
            break;
          default:
            Navigator.pushNamed(context, settingRoute);
        }
      },
      selectedIndex: get<SystemViewModel>().currentPageIndex,
      destinations: [
        NavigationDestination(
          selectedIcon: Icon(Icons.home, color: Colors.blue.shade800),
          icon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.meeting_room_rounded,
            color: Colors.blue.shade800,
          ),

          icon: Icon(Icons.meeting_room_rounded),
          label: "Rooms",
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.people_alt_rounded,
            color: Colors.blue.shade800,
          ),

          icon: Icon(Icons.people_alt_rounded),
          label: "Tenants",
        ),
        NavigationDestination(
          selectedIcon: Icon(
            Icons.payments_rounded,
            color: Colors.blue.shade800,
          ),

          icon: Icon(Icons.payments_rounded),
          label: "Payments",
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.settings, color: Colors.blue.shade800),
          icon: Icon(Icons.settings),
          label: "Setting",
        ),
      ],
    );
  }
}
