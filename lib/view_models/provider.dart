import 'package:flutter/material.dart';
import 'package:frontend/view_models/system_view_model.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationKey());
  locator.registerSingleton<SystemViewModel>(SystemViewModel());
}

class NavigationKey {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
