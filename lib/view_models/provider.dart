import 'package:flutter/material.dart';
import 'package:residenza/view_models/room_view_model.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => NavigationKey());
  locator.registerSingleton<SystemViewModel>(SystemViewModel());
  locator.registerSingleton<RoomViewModel>(RoomViewModel());
}

class NavigationKey {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
