import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ApplicationInfo {
  /// Prevents from object instantiation.
  ApplicationInfo._();

  static const appName = "Residenza";

  static const mainUrlDev =
      kIsWeb ? 'http://localhost:3300' : "http://10.0.2.2:3300";
  static const mainUrlProd = 'https://residenza.id';

  /// Set at build time with `--dart-define=APP_ENV=prod`.
  static const appEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const isProduction = appEnvironment == 'prod';

  /// Can be overridden at build time with `--dart-define=MAIN_URL=<url>`.
  ///
  /// Production defaults to [mainUrlProd], while development uses the local
  /// server appropriate for web or the Android emulator.
  static const mainUrl = String.fromEnvironment(
    'MAIN_URL',
    defaultValue: isProduction ? mainUrlProd : mainUrlDev,
  );

  static const baseUrl = "$mainUrl/service/api";

  static const appVersion = '1.2.5+3 ${isProduction ? "" : "DEV"}';

  static const secondColor = Color.fromARGB(255, 171, 203, 60);
  static const thirdColor = Colors.amber;

  //TODO: DEVELOPER SWITCH
  static const isDevelOn = false;
}
