import 'package:flutter/material.dart';
import 'package:residenza/features/auth/login_desktop.dart';
import 'package:residenza/features/auth/login_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginScreen extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<SystemViewModel>().checkSession(context: context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // get<SystemViewModel>().usernameController.dispose();
    // get<SystemViewModel>().passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: LoginDesktop(),
      mobileLayout: LoginMobile(),
    );
  }
}
