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
            Navigator.pushNamed(context, dashboardRoute);
            break;
          case 1:
            Navigator.pushNamed(context, productsRoute);
            break;
          case 2:
            Navigator.pushNamed(context, stockRoute);
            break;
          case 3:
            Navigator.pushNamed(context, clientsRoute);
            break;
          default:
            Navigator.pushNamed(context, settingsRoute);
          //   break;
          // default:
          //   Navigator.pushNamed(context, dashboardRoute);
        }
      },
      selectedIndex: get<SystemViewModel>().currentPageIndex,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Dashboard"),
        NavigationDestination(
          icon: Icon(Icons.factory_rounded),
          label: "Products",
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_checkout_rounded),
          label: "Stock",
        ),
        NavigationDestination(
          icon: Icon(Icons.store_rounded),
          label: "Clients",
        ),
        NavigationDestination(icon: Icon(Icons.settings), label: "Setting"),
      ],
    );
  }
}
