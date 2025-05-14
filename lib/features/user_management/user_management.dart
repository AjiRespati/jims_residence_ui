import 'package:flutter/material.dart';
import 'package:residenza/features/user_management/user_management_desktop.dart';
import 'package:residenza/features/user_management/user_management_mobile.dart';
import 'package:residenza/utils/responsive_layout.dart';
import 'package:residenza/view_models/system_view_model.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class UserManagement extends StatefulWidget with GetItStatefulWidgetMixin {
  UserManagement({super.key});

  @override
  State<UserManagement> createState() => _UserManagementState();
}

class _UserManagementState extends State<UserManagement> with GetItStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      get<SystemViewModel>().getAllUser().then((value) {
        List<dynamic> users = get<SystemViewModel>().users;
        List<dynamic> newusers =
            users
                .where(
                  (el) =>
                      el['username'] != get<SystemViewModel>().user['username'],
                )
                .toList();
        get<SystemViewModel>().users = newusers;
        get<SystemViewModel>().isBusy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      desktopLayout: UserManagementDesktop(),
      mobileLayout: UserManagementMobile(),
    );
  }
}
