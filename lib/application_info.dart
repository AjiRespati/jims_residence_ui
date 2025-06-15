import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const appName = "Residenza";

  static const mainUrlDev =
      kIsWeb ? 'http://localhost:3300' : "http://10.0.2.2:3300";
  static const mainUrlProd = 'https://residenza.id';

  //TODO: buat gonta ganti
  // static const mainUrl = mainUrlDev;
  static const mainUrl = mainUrlProd;

  static const isProduction = mainUrl == mainUrlProd;

  static const baseUrl = "$mainUrl/service/api";

  static const appVersion = '1.1.0 ${isProduction ? "" : "DEV"}';

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  //TODO: DEVELOPER SWITCH
  static const isDevelOn = true;
}
