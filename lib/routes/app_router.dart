import 'package:flutter/material.dart';
import 'package:residenza/features/all_tables/all_tables.dart';
import 'package:residenza/features/auth/login_screen.dart';
import 'package:residenza/features/home/home.dart';
import 'package:residenza/features/kost/kost.dart';
import 'package:residenza/features/payments/payment_resume_desktop.dart';
import 'package:residenza/features/payments/payment_list_desktop.dart';
import 'package:residenza/features/payments/payment_detail/payment_detail.dart';
import 'package:residenza/features/payments/payments.dart';
import 'package:residenza/features/price/price.dart';
import 'package:residenza/features/room/room_add_tenant/room_add_tenant.dart';
import 'package:residenza/features/room/room_settings/room_settings.dart';
import 'package:residenza/features/room/room_view.dart';
import 'package:residenza/features/room/room_detail/room_detail.dart';
import 'package:residenza/features/settings/settings.dart';
import 'package:residenza/features/tenant/tenant_detail/tenant_detail.dart';
import 'package:residenza/features/tenant/tenant_view.dart';
import 'package:residenza/features/user_management/user_management.dart';
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
        case roomAddTenantRoute:
          screen = RoomAddTenant();
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
        case userRoute:
          screen = UserManagement();
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
        case paymentsListRoute:
          screen = PaymentListDesktop();
          break;
        case paymentResumeRoute:
          screen = PaymentResumeDesktop();
          break;
        case allTablesRoute:
          screen = AllTables();
          break;
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
