import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:frontend/app.dart';
import 'package:frontend/view_models/provider.dart';
import 'package:frontend/view_models/system_view_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();

  bool isRegistered = locator.isRegistered<SystemViewModel>();
  if (!isRegistered) {
    setupLocator();
  }

  usePathUrlStrategy();

  runApp(const App());
}
