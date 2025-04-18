import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/features/kost/kost.dart';
import 'package:frontend/features/room/room_settings/room_settings.dart';
import 'package:frontend/features/room/room_view.dart';
import 'package:frontend/features/room/room_detail/room_detail.dart';
import 'package:frontend/features/settings/settings.dart';
import 'package:frontend/features/tenant/tenant_view.dart';
import '../widgets/not_found_page.dart';

import 'animate_route_transitions.dart';
import 'route_names.dart';

class AppRouter {
  static RouteFactory routes() {
    return ((settings) {
      dynamic arguments = settings.arguments;
      Widget screen;

      switch (settings.name) {
        case '/':
          screen = LoginScreen();
          break;
        case signInRoute:
          screen = LoginScreen();
          break;
        case homeRoute:
          screen = Home();
          break;
        case roomRoute:
          screen = RoomView();
          break;
        case roomDetailRoute:
          screen = RoomDetail(datas: arguments);
          break;
        case roomSettingsRoute:
          screen = RoomSettings(datas: arguments);
          break;
        case tenantRoute:
          screen = TenantView();
          break;
        case settingRoute:
          screen = Settings();
        case kostRoute:
          screen = Kost();
          break;
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
