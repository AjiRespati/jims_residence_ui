import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const appName = "Residenza";

  static const mainUrlDev =
      kIsWeb ? 'http://localhost:5000' : "http://10.0.2.2:5000";
  static const mainUrlProd = 'https://residenza.id';

  //TODO: buat gonta ganti
  //   static const mainUrl = mainUrlProd;

  /// API server host: on web, use the same host the page is served from
  /// (works for localhost, 127.0.0.1, or LAN IP from another device);
  /// API always runs on port 5000.
  static final String mainUrl = kIsWeb ? _hostFromPageOrigin : mainUrlDev;

  static String get _hostFromPageOrigin {
    final loc = Uri.base;
    if (loc.hasScheme && (loc.scheme == 'http' || loc.scheme == 'https')) {
      return '${loc.scheme}://${loc.host}:5000';
    }
    return 'http://localhost:5000';
  }

  static final bool isProduction = mainUrl == mainUrlProd;

  static final baseUrl = "$mainUrl/service/api";

  static const appVersion = '1.2.5+2 DEV';

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  //TODO: DEVELOPER SWITCH
  static const isDevelOn = false;
}
