import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const appName = "Residenza";

  static const mainUrlDev =
      kIsWeb ? 'http://localhost:3300' : "http://10.0.2.2:3300";
  static const mainUrlProd = 'https://jims.com';

  static const mainUrl = mainUrlDev;
  // static const mainUrl = mainUrlProd;

  static const isProduction = mainUrl == mainUrlProd;

  static const baseUrl = "$mainUrl/service/api";

  static const appVersion = '1.0.2 ${isProduction ? "" : "DEV"}';

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  static const measurements = [
    "kg",
    "g",
    "liter",
    "bucket",
    "carton",
    "box",
    "pcs",
  ];
}
