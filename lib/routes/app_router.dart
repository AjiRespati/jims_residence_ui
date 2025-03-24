import 'package:flutter/material.dart';
import 'package:frontend/features/auth/login_screen.dart';
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
        default:
          screen = const NotFoundPage();
      }

      return FadeRoute(page: screen, settings: settings);
    });
  }
}
