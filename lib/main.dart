import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:residenza/app.dart';
import 'package:residenza/view_models/provider.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  bool isRegistered = locator.isRegistered<SystemViewModel>();
  if (!isRegistered) {
    setupLocator();
  }

  usePathUrlStrategy();

  runApp(const App());
}
