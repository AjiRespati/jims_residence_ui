import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login_screen.dart';
import 'package:frontend/features/home/home.dart';
import 'package:frontend/features/kost/kost.dart';
import 'package:frontend/features/payments/payment_detail/payment_detail.dart';
import 'package:frontend/features/payments/payments.dart';
import 'package:frontend/features/price/price.dart';
import 'package:frontend/features/room/room_settings/room_settings.dart';
import 'package:frontend/features/room/room_view.dart';
import 'package:frontend/features/room/room_detail/room_detail.dart';
import 'package:frontend/features/settings/settings.dart';
import 'package:frontend/features/tenant/tenant_detail/tenant_detail.dart';
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
          screen = RoomView(isSetting: arguments);
          break;
        case roomDetailRoute:
          screen = RoomDetail();
          break;
        case roomSettingsRoute:
          screen = RoomSettings(datas: arguments);
          break;
        case tenantRoute:
          screen = TenantView();
          break;
        case tenantDetailRoute:
          screen = TenantDetail();
          break;
        case settingRoute:
          screen = Settings();
        case kostRoute:
          screen = Kost();
          break;
        case priceRoute:
          screen = Price();
          break;
        case paymentsRoute:
          screen = Payments();
          break;
        case paymentDetailRoute:
          screen = PaymentDetail();
          break;
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
